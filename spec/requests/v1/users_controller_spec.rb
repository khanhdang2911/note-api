require "rails_helper"
RSpec.describe Api::V1::UsersController, type: :request do
  describe "GET /api/v1/register" do
    context "when params is valid" do
      let(:valid_params) do
        {
          name: "Nguyen Van A",
          email: "nguyenvana@gmail.com",
          address: "123 Nguyen Van A",
          password: "12345678",
          password_confirmation: "12345678"
        }
      end
      subject(:request_call) { post "/api/v1/register", params: valid_params }
      it "return created status" do
        request_call
        expect(response).to have_http_status(:created)
      end
      it "return success message" do
        request_call
        expect(json["message"]).to eq("Register successfully!")
      end
      it "return the created user" do
        request_call
        expect(json["data"]).to include(
          "email" => valid_params[:email],
          "address" => valid_params[:address]
        )
      end
      it "generate a refresh token for the user" do
        request_call
        expect(json["data"]["refresh_token"]).to be_present
      end
    end
    context "when params is invalid" do
      let(:invalid_params) do
        {
          name: "Nguyen Van A",
          email: "nguyenvana.gmail.com"
        }
      end
      before { request_call }
      subject(:request_call) { post "/api/v1/register", params: invalid_params }
      it "return unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
  end
  end

  describe "POST /api/v1/login" do
    let(:user) { create(:user) }
    context "when params is valid" do
      let(:valid_params) do
        {
          email: user.email,
          password: user.password
        }
      end
      subject(:request_call) { post "/api/v1/login", params: valid_params }
      before { request_call }
      it "return ok status" do
        expect(response).to have_http_status(:ok)
      end
      it "return success message" do
        expect(json["message"]).to eq("Login successfully!")
      end
      it "return access token" do
        expect(json["data"]["access_token"]).to be_present
      end
      it "sets the refresh token in cookies" do
        expect(cookies[:refresh_token]).to be_present
      end
    end
    context "when params is invalid" do
      let(:invalid_params) { { email: "invalid_email", password: "wrong_password" } }
      subject(:request_call) { post "/api/v1/login", params: invalid_params }
      before { request_call }
      it "return unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end
      it "return error message" do
        expect(json["message"]).to eq("Invalid email or password, please try again.")
      end
    end
  end

  describe "POST /api/v1/refresh_token" do
    let(:user) { create(:user) }
    context "when refresh token is valid" do
      before do
        allow_any_instance_of(Api::V1::UsersController)
          .to receive(:get_refresh_token_from_cookies)
          .and_return(user.refresh_token)
      end
      context "when access token is valid" do
        before do
          get "/api/v1/refresh_token", headers: { "Authorization" => "Bearer #{JwtService.encode_token(user_id: user.id)}" }
        end
        it "return ok status" do
          expect(response).to have_http_status(:ok)
        end
        it "return success message" do
          expect(json["message"]).to eq("ok")
        end
        it "new access token is present" do
          expect(json["data"]["access_token"]).to be_present
        end
      end
      context "when access token is invalid" do
        before do
          get "/api/v1/refresh_token", headers: { "Authorization" => "Bearer #Invalid_access_token" }
        end
        it "return unauthorized status" do
          expect(response).to have_http_status(:unauthorized)
        end
        it "return error message" do
          expect(json["message"]).to eq("Unauthorized access")
        end
      end
    end
    context "when refresh token is invalid" do
      before do
        allow_any_instance_of(Api::V1::UsersController)
          .to receive(:get_refresh_token_from_cookies)
          .and_return("invalid_refresh_token")
      end
      context "when access token is valid" do
        before do
          get "/api/v1/refresh_token", headers: { "Authorization" => "Bearer #{JwtService.encode_token(user_id: user.id)}" }
        end
        it "return unauthorized status" do
          expect(response).to have_http_status(:unauthorized)
        end
        it "return error message" do
          expect(json["message"]).to eq("Unauthorized access")
        end
      end
      context "when access token is invalid" do
        before do
          get "/api/v1/refresh_token", headers: { "Authorization" => "Bearer #Invalid_access_token" }
        end
        it "return unauthorized status" do
          expect(response).to have_http_status(:unauthorized)
        end
        it "return error message" do
          expect(json["message"]).to eq("Unauthorized access")
        end
      end
    end
  end
end
