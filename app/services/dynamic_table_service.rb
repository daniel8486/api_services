class DynamicTableService
  def self.create_temp_table(table_name, columns)
    schema = "temp"
    full_table_name = "#{schema}.#{table_name}"

    # Cria o schema se não existir
    ActiveRecord::Base.connection.execute("CREATE SCHEMA IF NOT EXISTS #{schema}")

    return if ActiveRecord::Base.connection.data_source_exists?(full_table_name)

    ActiveRecord::Base.connection.create_table(full_table_name) do |t|
      columns.each { |col| t.string col }
      t.timestamps
    end
  end
end
