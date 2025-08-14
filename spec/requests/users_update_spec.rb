require 'rails_helper'

RSpec.describe "Users API", type: :request do
  describe "PUT /users" do
    let!(:admin_role) { Role.create!(role: 'Admin') }
    let!(:reader_role) { Role.create!(role: 'Arc Reader') }

    let(:user) { create(:user, roles: [admin_role]) }

    before do
      sign_in user
    end

    context "with valid attributes" do
      let(:valid_params) do
        {
          user: {
            username: "updated_username",
            first_name: "Updated",
            last_name: "User",
            bio: "Updated bio",
            facebook: "updated_fb",
            instagram: "updated_ig",
            x: "updated_x",
            charges_for_services: true,
            profile_picture: "updated_pic.jpg",
            roles: ["Arc Reader"]
          }
        }
      end

      it "updates the user and returns success" do
        put "/users/#{user.id}", params: valid_params

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["username"]).to eq("updated_username")
        expect(json["roles"].map { |r| r["role"] }).to include("Arc Reader")
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) do
        {
          user: {
            username: "", # Invalid: blank username
            roles: ["Arc Reader"]
          }
        }
      end

      it "returns error messages" do
        put "/users/#{user.id}", params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)

        expect(json["error"]).to include("Username can't be blank")
      end
    end
  end
end
