Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :notes
      resources :topics
      get "topics/:topic_id/notes", to: "notes#get_notes_by_topic"
    end
  end
end
