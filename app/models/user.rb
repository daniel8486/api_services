class User < ApplicationRecord
  belongs_to :company, optional: true
  mount_base64_uploader :avatar, AvatarUploader
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  validates :cpf, presence: true, uniqueness: true, format: { with: /\A\d{11}\z/, message: "Must contain exactly 11 numeric digits." }
  validates :password, presence: true, on: :create
  validates :password, confirmation: true, allow_blank: true
  validate :only_one_admin_allowed, on: :create
  validate :client_cannot_sign_up, on: :create
  validate :company_presence_unless_super_admin

  enum :role, { user: 0, admin: 1, client: 2, super_admin: 3, super_root: 4 }

  after_initialize do
    self.role = :user if new_record? && self.role.blank?
  end

  def generate_jwt
    JWT.encode(
      {
        sub: id,
        exp: 30.minutes.from_now.to_i,
        jti: jti # se você usa JTIMatcher
      },
      Rails.application.credentials.devise_jwt_secret_key!,
      "HS256"
    )
  end

  def only_one_admin_allowed
   if role == "admin" && User.admin.exists?
     errors.add(:role, :only_one_admin_allowed)
   end
  end

  def client_cannot_sign_up
    # Se não há usuário logado (sign_up via Devise) e está tentando criar um client
    if role == "client" && (Current.user.nil? rescue true)
      errors.add(:role, :client_cannot_sign_up)
    end
  end

  def company_presence_unless_super_admin
    if !super_admin? && !super_root? && company_id.nil?
     errors.add(:company, "deve ser preenchida para usuários que não são super_admin ou super_root")
    end
  end
end
