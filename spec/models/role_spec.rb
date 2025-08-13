require 'rails_helper'

RSpec.describe Role, type: :model do
  describe "Relationships:" do
    it { should have_many(:user_roles) }
    it { should have_many(:users).through(:user_roles) }
  end

  describe "Validations:" do
    it { should validate_presence_of(:role) }
    it { should validate_uniqueness_of(:role) }
  end
end