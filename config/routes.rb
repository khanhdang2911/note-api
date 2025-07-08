Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :notes
      resources :topics
      resources :users
      post "/register", to: "users#register"
      post "/login", to: "users#login"
      get "/refresh_token", to: "users#refresh_token"
      get "/topics/:topic_id/notes", to: "notes#get_notes_by_topic"
    end
  end
end
