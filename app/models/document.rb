class Document < ApplicationRecord
  belongs_to :type_document
  mount_base64_uploader :files, FileUploader
  # serialize :files, JSON
  belongs_to :client
end
