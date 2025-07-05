class DocumentSerializer
  include JSONAPI::Serializer
  attributes :id, :document_n, :type_document_id, :client_id

  attribute :files_url do |object|
    if object.files.present?
      # Se for caminho relativo, transformar em URL completa
      url = object.files.url
      if url.start_with?("/")
        # Para desenvolvimento local
        host = Rails.env.development? ? "http://localhost:3000" : "https://seudominio.com"
        "#{host}#{url}"
      else
        url
      end
    else
      nil
    end
  end

  belongs_to :type_document, serializer: TypeDocumentSerializer
end
