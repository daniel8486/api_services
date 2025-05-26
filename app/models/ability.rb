class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.super_root?
      can :manage, :all

    elsif user.super_admin?
      can :manage, :all

    elsif user.admin?
      # Admin pode gerenciar usuários da sua empresa (exceto super_admin e super_root)
      can :manage, User, company_id: user.company_id, role: %w[user admin client]
      can :read, Company, id: user.company_id
      can :manage, Client, company_id: user.company_id if defined?(Client)
      # Adicione outras permissões específicas para admin aqui

    elsif user.user?
      # User pode ler/atualizar seu próprio cadastro
      can [ :read, :update ], User, id: user.id
      # User pode criar clientes para sua empresa
      can :create, User, role: "client", company_id: user.company_id

    elsif user.client?
      # Cliente só pode ler/atualizar o próprio cadastro
      can [ :read, :update ], User, id: user.id
      # Pode ler sua própria fatura, se existir esse recurso
      can :read, Invoice, user_id: user.id if defined?(Invoice)
    end
  end
end
