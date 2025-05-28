class TypeDocumentSerializer
  include JSONAPI::Serializer
  attributes :id, :name

  has_many :documents, serializer: DocumentSerializer
end
