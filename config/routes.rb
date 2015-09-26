Rails.application.routes.draw do
  # TODO should probably lock this down a bit more
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :calendar_list, only: [:index]

end
