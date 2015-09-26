Rails.application.routes.draw do
  resources :calendar_list, only: [:index]

  post '/auth/google_oauth2/callback' => 'users/gplus_oauth_callback#callback'
end
