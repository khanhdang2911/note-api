module Api
  module V1
    class TopicsController < ApplicationController
    include Response
      def index
        topics = Topic.all
        json_response(topics, "Topics retrieved successfully")
      end
    end
  end
end
