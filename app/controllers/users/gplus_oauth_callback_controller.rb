require 'google/api_client/client_secrets'
require 'google/api_client'

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
      authorization.fetch_access_token!

      access_token = authorization.access_token
      puts "SDFJLSDFLJSDF"

      token = decode_id_token(authorization.id_token, client_secrets.client_id)
      render json: 'oauth auth failed', status: 401 if not token

      uid = token["id"]
      email = token["email"]
      user = User.find_or_create_by(uid: uid)

      # using Fred Guest's stateless API strategy
      # http://fredguest.com/2015/03/06/building-a-stateless-rails-api-with-react-and-twitter-oauth/
      jwt = JWT.encode({uid: user.uid, exp: 1.day.from_now.to_i}, Rails.application.secrets.secret_key_base)
      
      # is this okay?
      render json: { jwt: jwt }
    else
      render json: 'oauth auth failed', status: 401
    end
  end

  private

    # https://github.com/googleplus/gplus-verifytoken-ruby/blob/master/verify.rb
    def decode_id_token(id_token, client_id)
      # google's official ruby validator & example is horribly outdated

      # TODO must wrap it in this begin rescue because of outdated
      # implementation. i should investigate later and create a PR
      begin 
        validator = GoogleIDToken::Validator.new
        validator.check(id_token, client_id, client_id)
      rescue
      end

      return nil if validator.problem

      # TODO hack around existing validator
      validator.instance_variable_get("@token")[0]
    end  

end