Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :calendar_list, only: [:index]
    end
  end
  

  post '/auth/google_oauth2/callback' => 'users/gplus_oauth_callback#callback'
end
