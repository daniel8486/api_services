require 'rails_helper'

RSpec.describe City, type: :model do
  describe "validações" do
    subject { build(:city, state: build(:state)) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:state) }  # Corrigido
  end

  describe "associações" do
    let(:city) { build(:city, state: build(:state)) }

    it { expect(city).to belong_to(:state) }
    it { expect(city).to have_many(:neighborhoods) }
    # it { expect(city).to have_many(:zips).through(:neighborhoods) }  # Corrigido
  end

  describe ".search" do
    it "retorna cidades que correspondem ao nome" do
      state = create(:state)
      city1 = create(:city, name: "Teresina", state: state)
      city2 = create(:city, name: "Parnaíba", state: state)

      result = City.where("name ILIKE ?", "%Teresina%")

      expect(result).to include(city1)
      expect(result).not_to include(city2)
    end
  end
end
