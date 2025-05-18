module Api
  module V1
    class TopicsController < ApplicationController
    rescue_from ActiveRecord::RecordNotDestroyed, with: :handle_record_not_destroyed
    before_action :find_topic, only: %i[show update destroy]
    include Response
      def index
        topics = Topic.all
        json_response topics, "Topics retrieved successfully"
      end

      def show
        json_response @topic, "Topic retrieved successfully"
      end

      def create
        topic = Topic.new topic_params
        if topic.save
          json_response topic, "Topic created successfully", :created
        else
          json_error_response topic.errors.full_messages
        end
      end

      def update
        if @topic.update topic_params
          json_response @topic, "Topic updated successfully"
        else
          json_error_response @topic.errors.full_messages
        end
      end

      def destroy
        @topic.destroy!
        json_response nil, "Topic deleted successfully"
      end

      private
      def topic_params
        params.require(:topic).permit Topic::TOPIC_PARAMS
      end

      def user_params
        params.require(:user).permit User::USER_PARAMS
      end

      def find_topic
        @topic = Topic.find_by id: params[:id]
        json_error_response("Topic not found", :not_found) unless @topic
      end
    end
  end
end
