class ClientComparatorService
  def self.compare(imported_data)
    imported_data.map do |row|
      client = Client.find_by(cpf: row["cpf"]) 
      {
        imported: row,
        exists: client.present?,
        client: client&.attributes&.slice("id", "name", "email", "cpf")
      }
    end
  end
end
