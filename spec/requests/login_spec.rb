require 'rails_helper'

RSpec.describe "User login", type: :request do
  let(:user) { create(:user, password: "password123") }

  it "logs in the user and returns a JWT token" do
    post "/login", params: {
      user: {
        email: user.email,
        password: "password123"
      }
    }, as: :json

    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)

    expect(json["status"]["message"]).to eq("Logged in successfully.")
    expect(json["status"]["token"]).to be_present
    expect(json["status"]["data"]["user"]["email"]).to eq(user.email)
  end

  it "fails with invalid credentials" do
    post "/login", params: {
      user: {
        email: user.email,
        password: "wrongpassword"
      }
    }, as: :json

    expect(response).to have_http_status(:unauthorized)

    json = JSON.parse(response.body)

    expect(json["error"]).to eq("Invalid Email or password.")
  end
end
