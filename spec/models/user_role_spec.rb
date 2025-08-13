require "rails_helper"

RSpec.describe UserRole, type: :model do
  describe "Relationships:" do
    it { should belong_to(:user) }
    it { should belong_to(:role) }
  end
end
