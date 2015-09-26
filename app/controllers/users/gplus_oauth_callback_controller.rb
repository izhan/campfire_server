require 'google/api_client/client_secrets'

# TODO this should not be here
CLIENT_SECRETS_FILE = Rails.root.join('config', 'oauth', 'gplus_client_secret.json')

class Users::GplusOauthCallbackController < ApplicationController
  def callback
    puts "in callbaddsckd"
    puts params
    puts params[:code]
    if params[:code]
      puts "within if"
      client_secrets = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_FILE)
      authorization = client_secrets.to_authorization
      authorization.scope = 'https://www.googleapis.com/auth/calendar'
      authorization.code = params[:code]
      authorization.redirect_uri = "postmessage"

      puts "here"
      puts authorization
      asdf = authorization.fetch_access_token!
      puts "there"
      puts asdf
    end
  end
end