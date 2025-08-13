require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let(:admin_role) { Role.create(role: "Admin") }
  let(:author_role) { Role.create(role: "Author") }

  let(:admin_user) { create(:user, password: "password123", roles: [admin_role]) }
  let(:author_user) { create(:user, password: "password123", roles: [author_role]) }

  let(:admin_token) do
    Warden::JWTAuth::UserEncoder.new.call(admin_user, :user, nil).first
  end

  let(:author_token) do
    Warden::JWTAuth::UserEncoder.new.call(author_user, :user, nil).first
  end

  describe "GET /users" do
    it "returns all users for admin" do
      get "/users", headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.first).to have_key("email")
    end

    it "returns forbidden for non-admin user" do
      get "/users", headers: { "Authorization" => "Bearer #{author_token}" }

      expect(response).to have_http_status(:forbidden)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Unauthorized")
    end
  end
end
