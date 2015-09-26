require 'google/api_client/client_secrets'

CLIENT_SECRETS_FILE = Rails.root.join('config', 'oauth', 'gplus_client_secret.json')

class Users::GplusOauthCallbackController < ApplicationController
  def callback
    puts "in callback"
    if params[:code]
      puts "within if"
      client_secrets = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_FILE)
      authorization = client_secrets.to_authorization
      authorization.scope = 'https://www.googleapis.com/auth/calendar'
      authorization.code = params[:code]

      puts "here"
      asdf = authorization.fetch_access_token!
      puts "there"
      puts asdf
    end
  end
end