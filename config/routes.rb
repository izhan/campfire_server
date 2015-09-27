Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :calendar_lists, only: [:index]
    end
  end
  
  get "/auth/current_user" => "application#current_user"

  post '/auth/google_oauth2/callback' => 'users/gplus_oauth_callback#callback'
end
