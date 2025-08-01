module Api
  module V1
    class NotesController < ApplicationController
      before_action :find_note, only: %i[show update destroy]
      before_action :find_topic, only: %i[get_notes_by_topic]
      def index
        notes = Note.all
        json_response notes, "Notes retrieved successfully"
      end

      def show
        json_response @note, "Note retrieved successfully"
      end

      def create
        note = Note.new note_params
        if note.save
          json_response note, "Note created successfully", :created
        else
          json_error_response note.errors.full_messages
        end
      end

      def update
        if @note.update note_params
          json_response @note, "Note updated successfully"
        else
          json_error_response @note.errors.full_messages
        end
      end

      def destroy
        @note.destroy!
        json_response nil, "Note deleted successfully"
      end

      def get_notes_by_topic
        notes = Note.where topic_id: params[:topic_id]
        json_response notes, "Notes retrieved successfully"
      end


      private
      def note_params
        params.require(:note).permit Note::NOTE_PARAMS
      end

      def find_note
        @note = Note.find_by id: params[:id]
        json_error_response("Note not found", :not_found) unless @note
      end

      def find_topic
        @topic = Topic.find_by id: params[:topic_id]
        json_error_response("Topic not found", :not_found) unless @topic
      end
    end
  end
end
