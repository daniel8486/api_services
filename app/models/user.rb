class User < ApplicationRecord
  belongs_to :company, optional: true
  has_many :contracts, foreign_key: :client_id
  has_many :cash_registers
  mount_base64_uploader :avatar, AvatarUploader
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  validates :cpf, presence: true, uniqueness: true, format: { with: /\A\d{11}\z/, message: "Must contain exactly 11 numeric digits." }
  # validates :password, presence: true, on: :create
  # validates :password, confirmation: true, allow_blank: true
  validate :only_one_admin_allowed, on: :create
  validate :client_cannot_sign_up, on: :create
  validate :company_presence_unless_super_admin
  validate :only_one_admin_per_company, if: -> { admin? && company_id.present? }, on: :create

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
   if role == "admin" && User.where(company_id: company_id, role: :admin).exists?
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

  def only_one_admin_per_company
    puts "DEBUG: company_id=#{company_id}, role=#{role.inspect} (class: #{role.class})"
    return unless company_id.present? && (role == "admin" || role == :admin || role == User.roles[:admin] || role.to_s == "admin")
    admin_value = User.roles[:admin]
    if User.where(company_id: company_id, role: admin_value).exists?
      errors.add(:base, "Já existe um admin para esta empresa")
    end
  end

  def adimplencia
   Installment.joins(:contract).where(contracts: { client_id: id }, status: "paga").count
  end

  def inadimplencia
   Installment.joins(:contract).where(contracts: { client_id: id }, status: "atrasada").count
  end
end
