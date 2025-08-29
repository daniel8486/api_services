require 'rails_helper'

RSpec.describe User, type: :model do
  let(:company) { create(:company) }

  describe "validações básicas" do
    it { should validate_presence_of(:cpf) }
    it { should validate_uniqueness_of(:cpf) }
    it { should allow_value("12345678901").for(:cpf) }
    it { should_not allow_value("1234567890").for(:cpf) }
    it { should_not allow_value("abc").for(:cpf) }
    # it { should belong_to(:company).optional }
    it { should have_many(:contracts) }
    it { should have_many(:cash_registers) }
  end

  describe "validação de presença de company" do
    it "é inválido para user comum sem company" do
      user = build(:user, role: :user, company: nil, cpf: "12345678901", password: "123456", email: "teste@email.com")
      expect(user).to_not be_valid
      expect(user.errors[:company]).to include("deve ser preenchida para usuários que não são super_admin ou super_root")
    end

    it "é válido para super_admin sem company" do
      user = build(:user, role: :super_admin, company: nil, cpf: "12345678901", password: "123456", email: "super@email.com")
      expect(user).to be_valid
    end

    it "é válido para super_root sem company" do
      user = build(:user, role: :super_root, company: nil, cpf: "12345678901", password: "123456", email: "root@email.com")
      expect(user).to be_valid
    end
  end

  describe "validação de admin único por empresa" do
    it "não permite criar dois admins para a mesma empresa" do
      create(:user, role: :admin, company: company, cpf: "12345678901", password: "123456", email: "admin1@email.com")
      user2 = build(:user, role: :admin, company: company, cpf: "12345678902", password: "123456", email: "admin2@email.com")
      expect(user2).to_not be_valid
      expect(user2.errors[:role]).to include("Só é permitido criar o primeiro admin via API. Novos admins só podem ser criados por um admin já cadastrado.")
    end
  end

  describe "validação condicional de presença de company" do
  it "é inválido para user comum sem company" do
    user = build(:user, role: :user, company: nil)
    expect(user).to_not be_valid
    # expect(user.errors[:company]).to include("deve ser preenchida para usuários que não são admin, super_admin ou super_root")
    expect(user.errors[:company]).to include("deve ser preenchida para usuários que não são super_admin ou super_root")
  end

  it "é válido para admin sem company" do
    user = build(:user, role: :admin, company: nil)
    expect(user).to_not be_valid
    expect(user.errors[:company]).to include("deve ser preenchida para usuários que não são super_admin ou super_root")
  end

  it "é válido para super_admin sem company" do
    user = build(:user, role: :super_admin, company: nil)
    expect(user).to be_valid
  end

  it "é válido para super_root sem company" do
    user = build(:user, role: :super_root, company: nil)
    expect(user).to be_valid
  end
end

  describe "validação de client_cannot_sign_up" do
    before do
      # stub_const("Current", Class.new)
      # allow(Current).to receive(:user).and_return(nil)
      stub_const("Current", Class.new do
        def self.user; nil; end
      end)
    end

    it "não permite criar client sem usuário logado" do
      user = build(:user, role: :client, company: company, cpf: "12345678903", password: "123456", email: "client@email.com")
      expect(user).to_not be_valid
      # expect(user.errors[:role]).to include("client_cannot_sign_up")
      expect(user.errors[:role]).to include("Cliente não pode ser criado via sign up. Apenas usuários autenticados podem criar clientes.")
    end
  end

  describe "validação de email e senha" do
    it "é inválido sem email" do
      user = build(:user, email: nil, password: "123456", cpf: "12345678901", company: company)
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("não pode ficar em branco")
    end

    it "é inválido sem senha" do
      user = build(:user, email: "teste@email.com", password: nil, cpf: "12345678901", company: company)
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("não pode ficar em branco")
    end

    it "é inválido com senha menor que 6 caracteres" do
      user = build(:user, email: "teste@email.com", password: "123", cpf: "12345678901", company: company)
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("é muito curto (mínimo: 6 caracteres)")
    end

    it "é inválido com email duplicado" do
      create(:user, email: "duplicado@email.com", password: "123456", cpf: "12345678901", company: company)
      user = build(:user, email: "duplicado@email.com", password: "123456", cpf: "12345678902", company: company)
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("já está em uso")
    end
  end

  describe "#admin?" do
    it "retorna true se o usuário for admin" do
      user = build(:user, role: :admin, company: company, cpf: "12345678901", password: "123456", email: "admin@email.com")
      expect(user.admin?).to be true
    end

    it "retorna false se o usuário não for admin" do
      user = build(:user, role: :user, company: company, cpf: "12345678901", password: "123456", email: "user@email.com")
      expect(user.admin?).to be false
    end
  end

  describe "#adimplencia e #inadimplencia" do
    it "retorna 0 se não houver parcelas pagas ou atrasadas" do
      user = create(:user, company: company, cpf: "12345678901", password: "123456", email: "teste@email.com")
      expect(user.adimplencia).to eq(0)
      expect(user.inadimplencia).to eq(0)
    end
    # Para entender a adimplência e inadimplência
  end
end
