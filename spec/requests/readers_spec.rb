# spec/requests/readers_spec.rb
require 'rails_helper'

RSpec.describe "Readers API", type: :request do
  describe "GET /readers" do
    let!(:arc_role) { Role.create!(role: 'Arc Reader') }
    let!(:beta_role) { Role.create!(role: 'Beta Reader') }
    let!(:proof_role) { Role.create!(role: 'Proof Reader') }
    let!(:non_reader_role) { Role.create!(role: 'Admin') }

    let!(:arc_reader) { create(:user, roles: [arc_role]) }
    let!(:beta_reader) { create(:user, roles: [beta_role]) }
    let!(:proof_reader) { create(:user, roles: [proof_role]) }
    let!(:non_reader) { create(:user, roles: [non_reader_role]) }

    let(:auth_user) { create(:user) }

    before do
      sign_in auth_user
      get "/readers"
    end

    it "returns success status" do
      expect(response).to have_http_status(:ok)
    end

    it "returns only users with reader roles" do
      json = JSON.parse(response.body)
      usernames = json['readers'].map { |r| r['username'] }

      expect(usernames).to include(arc_reader.username)
      expect(usernames).to include(beta_reader.username)
      expect(usernames).to include(proof_reader.username)
      expect(usernames).not_to include(non_reader.username)
    end

    it "includes expected fields in response" do
      json = JSON.parse(response.body)
      reader = json['readers'].first

      expect(reader.keys).to include(
        'id', 'username', 'first_name', 'last_name', 'email',
        'bio', 'profile_picture', 'roles', 'charges_for_services',
        'facebook', 'instagram', 'x', 'created_at', 'updated_at'
      )
    end
  end
end
