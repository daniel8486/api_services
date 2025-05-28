class DocumentSerializer
  include JSONAPI::Serializer
  attributes :id, :document_n, :type_document_id, :client_id  # ,:files

  attribute :files_url do |object|
    object.files.url if object.files.present?
  end

  belongs_to :type_document
end
