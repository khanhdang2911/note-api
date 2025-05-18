require "rails_helper"

RSpec.describe Api::V1::TopicsController, type: :request do
  let!(:user)    { create(:user) }
  let!(:topics)  { create_list(:topic, 2, user: user) }
  let(:topic) { topics.first }
  let(:not_found_id) { 0 }
  shared_examples "not found response" do
    it "returns not found response" do
      expect(response).to have_http_status(:not_found)
    end
    it "returns not found message" do
      expect(json["message"]).to include("Topic not found")
    end
  end
  describe "GET /api/v1/topics" do
    subject(:request_call) { get "/api/v1/topics" }

    before { request_call }

    it { expect(response).to have_http_status(:ok) }

    it "returns all topics" do
      expect(json["data"].size).to eq(topics.size)
    end
  end

  describe "GET /api/v1/topics/:id" do
    context "when topic exists" do
      subject(:request_call) { get "/api/v1/topics/#{topic.id}" }
      before { request_call }

      it { expect(response).to have_http_status(:ok) }
      it "returns the topic" do
        expect(json["data"]["id"]).to eq(topic.id)
      end
    end

    context "when topic does not exist" do
      before { get "/api/v1/topics/#{not_found_id}" }
      it_behaves_like "not found response"
    end
  end

  describe "POST /api/v1/topics" do
    context "when params are valid" do
      let(:valid_params) do
          {
            topic: {
              name: "New topic",
              description: "New topic description",
              user_id: user.id
            }
          }
      end
      subject(:request_call) { post "/api/v1/topics", params: valid_params }
      before { request_call }
      it { expect(response).to have_http_status(:created) }
      it "return the created topic" do
        expect(json["data"]).to include(
          "name" => valid_params[:topic][:name],
          "description" => valid_params[:topic][:description],
          "user_id" => valid_params[:topic][:user_id]
        )
      end
    end
    context "when params are invalid" do
      let (:invalid_params) do
        {
          topic: {
            name: "",
            description: "New topic description",
            user_id: not_found_id
          }
        }
      end
      subject(:request_call) { post "/api/v1/topics", params: invalid_params }
      before { request_call }
      it { expect(response).to have_http_status(:unprocessable_entity) }
      it "return error message" do
        expect(json["message"]).to include(
          "Name can't be blank",
          "User must exist"
        )
      end
    end
  end

  describe "PATCH /api/v1/topics/:id" do
    context "when topic exists" do
      let(:valid_params) do
        {
          topic: {
            name: "Updated topic",
            description: "Updated topic description"
          }
        }
      end
      subject(:request_call) { patch "/api/v1/topics/#{topic.id}", params: valid_params }
      before { request_call }
      it { expect(response).to have_http_status(:ok) }
      it "return the updated topic" do
        expect(json["data"]).to include(
          "name" => valid_params[:topic][:name],
          "description" => valid_params[:topic][:description],
          "user_id" => topic.user_id
        )
      end
    end

    context "when topic does not exist" do
      before { patch "/api/v1/topics/#{not_found_id}" }
      it_behaves_like "not found response"
    end
  end

  describe "DELETE /api/v1/topics/:id" do
    context "when topic exists" do
      subject(:request_call) { delete "/api/v1/topics/#{topic.id}" }
      before { delete "/api/v1/topics/#{topic.id}" }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when topic does not exist" do
      before { delete "/api/v1/topics/#{not_found_id}" }
      it_behaves_like "not found response"
    end
  end
end
