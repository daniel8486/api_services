class ImportedClientsToSystemService
  def self.import_from_temp_table(table_name, schema = "temp")
    full_table_name = "#{schema}.#{table_name}"
    klass = Class.new(ActiveRecord::Base) { self.table_name = full_table_name }
    klass.all.each do |row|
      next if row["cpf"].blank? || row["company_id"].blank?
      client = Client.find_by(cpf: row["cpf"], company_id: row["company_id"])
      unless client
        Client.create!(
          name: row["name"],
          email: row["email"],
          cpf: row["cpf"],
          company_id: row["company_id"]
          # outros campos conforme necessário
        )
      end
    end
  end
end
