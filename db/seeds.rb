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
#  end
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

# if User.exists?
#   puts "Usuários já existem, pulando criação de usuários."
# else
#   puts "Criando usuários padrão..."
#   User.create!(
#     email: "superroot@superadmin.com",
#     password: "@5893475873fohsdklfhskdr789hfskldhflksh@@",
#     cpf: "12345678901",
#     role: 4, # super_root
#   )
# end
#
# if DegreeDependent.exists?
#   puts "Graus de parentesco já existem, pulando criação de graus."
#   degree_dependents = []
# else
#   puts "Criando graus de parentesco padrão..."
#   degree_dependents = [
#     { description: 'Filho' },
#     { description: 'Pai' },
#     { description: 'Mãe' },
#     { description: 'Sobrinho' },
#     { description: 'Outros - Não Especificados' }
#   ]
# end
#
# degree_dependents.each do |dependent|
#   DegreeDependent.find_or_create_by!(dependent)
# end
#
# if TypeDocument.exists?
#   puts "Tipos de documentos já existem, pulando criação de tipos."
#   type_documents = []
# else
#   puts "Criando Tipos de Documentos Padrões..."
#   type_documents = [
#     { name: 'CPF' },
#     { name: 'RG - FRENTE' },
#     { name: 'RG - VERSO' },
#     { name: 'CNH' },
#     { name: 'Passaporte' },
#     { name: 'Comprovante de Endereço' },
#     { name: 'Outros - Não Especificados' },
#     { name: 'Todos acima em PDF' }
#   ]
# end
#
# type_documents.each do |document|
#   TypeDocument.find_or_create_by!(document)
# end
#

# Verificar se já executou antes
# if Rails.cache.exist?('seeds_executed')
#   puts "⏭️  Seeds already executed recently, skipping..."
#   exit
# end

require 'csv'

puts "🌱 Starting seed process..."

begin
  # Verificar se estamos em produção
  puts "Environment: #{Rails.env}"

  # 1. Criar usuário super admin
  puts "👤 Checking for existing users..."
  user_count = User.count
  puts "Found #{user_count} users"

  if user_count == 0
    puts "Creating super admin user..."

    user = User.new(
      email: "daniel@sysdjamsofthouse.com.br",
      password: "@5893475873fohsdklfhskdr789hfskldhflksh@@",
      cpf: "00708721397",
      role: 4 # super_root
    )

    if user.save
      puts "✅ Super admin user created successfully!"
    else
      puts "❌ Failed to create user: #{user.errors.full_messages.join(', ')}"
    end
  else
    puts "✅ Users already exist (#{user_count} users found)"
  end

  # 2. Criar graus de parentesco
  puts "👨‍👩‍👧‍👦 Checking degree dependents..."
  degree_count = DegreeDependent.count
  puts "Found #{degree_count} degree dependents"

  if degree_count == 0
    puts "Creating degree dependents..."
    degree_dependents = [
      { description: 'Filho' },
      { description: 'Pai' },
      { description: 'Mãe' },
      { description: 'Sobrinho' },
      { description: 'Outros - Não Especificados' }
    ]

    degree_dependents.each do |dependent|
      dd = DegreeDependent.new(dependent)
      if dd.save
        puts "✅ Created: #{dd.description}"
      else
        puts "❌ Failed to create degree dependent: #{dd.errors.full_messages.join(', ')}"
      end
    end
  else
    puts "✅ Degree dependents already exist (#{degree_count} found)"
  end

  # 3. Criar tipos de documentos
  puts "📄 Checking document types..."
  doc_count = TypeDocument.count
  puts "Found #{doc_count} document types"

  if doc_count == 0
    puts "Creating document types..."
    type_documents = [
      { name: 'CPF' },
      { name: 'RG - FRENTE' },
      { name: 'RG - VERSO' },
      { name: 'CNH' },
      { name: 'Passaporte' },
      { name: 'Comprovante de Endereço' },
      { name: 'Outros - Não Especificados' },
      { name: 'Todos acima em PDF' }
    ]

    type_documents.each do |document|
      td = TypeDocument.new(document)
      if td.save
        puts "✅ Created: #{td.name}"
      else
        puts "❌ Failed to create document type: #{td.errors.full_messages.join(', ')}"
      end
    end
  else
    puts "✅ Document types already exist (#{doc_count} found)"
  end

  puts "🎉 Seed process completed!"
  puts "📊 Final counts:"
  puts "   Users: #{User.count}"
  puts "   DegreeDependent: #{DegreeDependent.count}"
  puts "   TypeDocument: #{TypeDocument.count}"

rescue => e
  puts "❌ Error during seed process: #{e.message}"
  puts "🔍 Backtrace:"
  puts e.backtrace.first(10).join("\n")
  raise e
end
