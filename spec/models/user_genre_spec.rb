require "rails_helper"

RSpec.describe UserGenre, type: :model do
  describe "Relationships:" do
    it { should belong_to(:user) }
    it { should belong_to(:genre) }
  end
end
