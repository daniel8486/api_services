class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    return unless user.persisted?

    if user.super_root?
      can :manage, :all

    elsif user.super_admin?
      can :manage, :all

    elsif user.admin?
      # Admin pode gerenciar usuários da sua empresa (exceto super_admin e super_root)
      can :manage, User, company_id: user.company_id, role: %w[user admin client]
      can :read, Company, id: user.company_id
      can :manage, Client, company_id: user.company_id if defined?(Client)

      can :manage, Plan, company_id: user.company_id
      can :manage, Campaign, company_id: user.company_id
      can :manage, Contract, company_id: user.company_id

    elsif user.user?
      # User pode ler/atualizar seu próprio cadastro
      can [ :read, :update ], User, id: user.id
      # User pode criar clientes para sua empresa
      can :create, User, role: "client", company_id: user.company_id
      can [ :read, :create, :update ], Client, company_id: user.company_id
      can [ :read, :create, :update ], Plan, company_id: user.company_id
      can [ :read, :create, :update ], Campaign, company_id: user.company_id
      can [ :read, :create, :update ], Contract, company_id: user.company_id
      can :is_valid_token, User if user.present?

    elsif user.client?
      # Cliente só pode ler/atualizar o próprio cadastro
      can [ :read, :update ], User, id: user.id
      # Pode ler sua própria fatura
      can :read, Invoice, user_id: user.id if defined?(Invoice)
      can :read, Contract, client_id: user.id
    end
  end
end
