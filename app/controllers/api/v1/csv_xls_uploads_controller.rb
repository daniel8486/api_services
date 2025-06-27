class Api::V1::CsvXlsUploadsController < ApplicationController
  # 1º passo: Upload e análise do arquivo
  def import_clients
    file = params[:file]
    return render json: { error: "Arquivo não enviado" }, status: :bad_request unless file

    if file.content_type == "text/csv"
      table = CSV.parse(file.read, headers: true)
      columns = table.headers
      sample = table.first&.to_h
      data = table.map(&:to_h)
    elsif file.content_type.in?([ "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/vnd.ms-excel" ])
      xlsx = Roo::Spreadsheet.open(file.path)
      columns = xlsx.row(1)
      sample = Hash[columns.zip(xlsx.row(2))]
      data = []
      (2..xlsx.last_row).each do |i|
        data << Hash[columns.zip(xlsx.row(i))]
      end
    else
      return render json: { error: "Formato não suportado" }, status: :unprocessable_entity
    end

    # Salve os dados em cache ou banco temporário para o próximo passo
    key = SecureRandom.hex(10)
    Rails.cache.write("import_#{key}", { columns: columns, data: data }, expires_in: 30.minutes)

    render json: {
      columns: columns,
      sample: sample,
      import_key: key,
      message: "Deseja criar uma tabela com essas colunas?"
    }
  end

  # 2º passo: Confirmação, criação da tabela e comparação
  def confirm_import
     key = params[:import_key]
     table_name = params[:table_name] || "imported_clients"
     schema = "temp"
     full_table_name = "#{schema}.#{table_name}"
     cache = Rails.cache.read("import_#{key}")
     return render json: { error: "Importação expirada ou não encontrada" }, status: :not_found unless cache

     columns = cache[:columns]
     data = cache[:data]

     # Cria a tabela temporária no schema temp
     DynamicTableService.create_temp_table(table_name, columns)

     # Registra a importação pendente para aprovação
     PendingImportTable.create!(
       table_name: table_name,
       schema: schema,
       user: current_user,
       expires_at: 48.hours.from_now
     )

     # Insere os dados na tabela criada
     klass = Class.new(ActiveRecord::Base) do
       self.table_name = full_table_name
     end
     data.each { |row| klass.create!(row) }

     # Agenda a exclusão automática em 48h
     DropTempTableJob.set(wait: 48.hours).perform_later(full_table_name)

     # Compara com clientes existentes (por CPF)
     comparacao = ClientComparatorService.compare(data)

     render json: {
       table: full_table_name,
       imported_count: data.size,
       comparacao: comparacao.take(10),
       message: "Tabela temporária criada e agendada para exclusão em 48h."
     }
  end
end
