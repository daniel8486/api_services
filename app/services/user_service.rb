class UserService
  def self.serialize_users(users)
    UserSerializer.new(users, include: [ :company ]).serializable_hash
  end

  def self.serialize_user(user)
    UserSerializer.new(user, include: [ :company ]).serializable_hash
  end
end
