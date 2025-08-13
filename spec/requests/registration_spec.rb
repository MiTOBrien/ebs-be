require 'rails_helper'
require 'ostruct'

RSpec.describe "User Registration", type: :request do
  before do
    Role.create!(role: "Author")
    Role.create!(role: "Beta Reader")

    allow_any_instance_of(Users::RegistrationsController).to receive(:create_stripe_customer).and_return(OpenStruct.new(id: "cus_test"))
    allow_any_instance_of(Users::RegistrationsController).to receive(:create_stripe_subscription).and_return(
      OpenStruct.new(
        id: "sub_test",
        current_period_start: Time.now.to_i,
        current_period_end: (Time.now + 30.days).to_i
      )
    )
  end

  let(:subscription_type) { "monthly" }

  let(:valid_attributes) do
    {
      user: {
        username: "testuser",
        first_name: "Test",
        last_name: "User",
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123",
        subscription_type: subscription_type,
        roles: ["author", "betareader"]
      }
    }
  end

  it "creates a new user and returns a JWT token" do
    expect {
      puts valid_attributes
      post "/signup", params: valid_attributes, as: :json
      puts response.body
    }.to change(User, :count).by(1)

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["status"]["message"]).to eq("Signed up successfully.")
    expect(json["status"]["token"]).to be_present
    expect(json["status"]["data"]["email"]).to eq("test@example.com")
  end

  it "assigns roles to the user" do
    post "/signup", params: valid_attributes, as: :json
    user = User.find_by(email: "test@example.com")
    expect(user.roles.map(&:role)).to include("Author", "Beta Reader")
  end

  context "with free subscription" do
    let(:subscription_type) { "free" }

    it "creates a free subscription" do
      post "/signup", params: valid_attributes, as: :json
      user = User.find_by(email: "test@example.com")
      expect(user.subscriptions.count).to eq(1)
      expect(user.subscriptions.first.subscription_type).to eq("free")
      expect(user.subscription_status).to eq("active")
    end
  end

  context "with paid subscription" do
    let(:subscription_type) { "monthly" }

    it "creates a paid subscription and sets status to incomplete" do
      post "/signup", params: valid_attributes, as: :json
      user = User.find_by(email: "test@example.com")
      expect(user.subscriptions.count).to eq(1)
      expect(user.subscriptions.first.subscription_type).to eq("monthly")
      expect(user.subscription_status).to eq("incomplete")
    end
  end

  context "when user creation fails" do
    it "returns an error message" do
      invalid_params = {
        user: {
          email: "",
          password: "123",
          password_confirmation: "456"
        }
      }

      post "/signup", params: invalid_params, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["status"]["message"]).to include("User couldn't be created successfully")
    end
  end
end
