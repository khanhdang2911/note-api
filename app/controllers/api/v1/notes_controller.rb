module Api
  module V1
    class NotesController < ApplicationController
      include Response
      def index
        notes = Note.all
        json_response(notes, "Notes retrieved successfully")
      end
    end
  end
end
