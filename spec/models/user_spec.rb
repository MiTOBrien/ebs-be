require "rails_helper"

RSpec.describe User, type: :model do
  describe "Relationships:" do
    it { should have_many(:subscriptions) }
    it { should have_many(:user_roles) }
    it { should have_many(:roles).through(:user_roles) }
    it { should have_many(:user_genres) }
    it { should have_many(:genres).through(:user_genres) }
  end

  describe "Validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end
end