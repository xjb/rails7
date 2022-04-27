require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /sign_in" do
    it "returns http success" do
      get "/sign_in"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /sign_out" do
    it "returns http success" do
      get "/sign_out"
      expect(response).to redirect_to sign_in_path
    end
  end
end
