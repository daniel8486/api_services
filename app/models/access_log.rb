class AccessLog < ApplicationRecord
  belongs_to :user, optional: true
end
