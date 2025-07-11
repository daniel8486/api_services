# app/serializers/user_serializer.rb
class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :role, :cpf, :created_at, :updated_at

  # ✅ CORREÇÃO: Garantir que não retorne arrays
  def self.serialize(user)
    {
      id: user.id,
      email: user.email,
      role: user.role,
      cpf: user.cpf,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
