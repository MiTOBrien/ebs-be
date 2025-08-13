require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe "Relationships:" do
    it { should have_many(:user_genres) }
    it { should have_many(:users).through(:user_genres) }
  end

  describe "Validations:" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
