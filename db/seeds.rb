require 'csv'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# 1º Cria os estados
# CSV.foreach(Rails.root.join('db/estados.csv'), headers: true) do |row|
#   State.create!(
#     code: row['codigo_uf'],
#     name: row['nome'],
#     acronym: row['uf'],
#     region: row['regiao'],
#     latitude: row['latitude'],
#     longitude: row['longitude']
#   )
# end
# 2º Edita via SQL os CODE que viram vazios
# 3º Cria os municípios
# CSV.foreach(Rails.root.join('db/municipios_.csv'), headers: true) do |row|
#   state = State.find_by(code: row['CODE'].to_i)
#   if state
#     City.create!(
#       id: row['COD_MUNICIPIO_IBGE'],
#       code: row['CODE'],
#       name: row['MUNICIPIO_A'],
#       name_ibge: row['MUNICIPIO_IBGE'],
#       state: state,
#       latitude: row['LATITUDE'],
#       longitude: row['LONGITUDE'],
#       capital: row['capital'] == '1',
#       ddd: row['ddd'],
#       timezone: row['fuso_horario']
#     )
#   else
#     puts "Estado não encontrado para UF: #{row['UF']} (cidade: #{row['MUNICIPIO_A']})"
#   end
# end
# 4º Cria os bairros
# CSV.foreach('db/pi.cepaberto_parte_5.csv', headers: true) do |row|
#   city = City.find_by(code: 22) # Teresina
#   next unless city
#
#   neighborhood = Neighborhood.find_or_create_by!(
#     name: row['Localidade'].to_s.strip,
#     city: city,
#     locality: row['Logradouro'].to_s.strip,
#   )
#
#   Zip.create!(
#     code: row['CEP'],
#     street: row['Logradouro'],
#     neighborhood: neighborhood,
#     city: city,
#     zone: row['Bairro'],
#   )
# end


User.create!(
  email: "superroot@superadmin.com",
  password: "123456789123131",
  cpf: "12345678901",
  role: 4, # super_root
)
