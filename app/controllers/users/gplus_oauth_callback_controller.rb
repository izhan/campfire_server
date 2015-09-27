require 'google/api_client/client_secrets'

class Users::GplusOauthCallbackController < ApplicationController
  def callback
    puts "in callback"

    if params[:code]
      puts params[:code]
      client_secrets = get_api_client()
      authorization = client_secrets.to_authorization
      authorization.scope = 'https://www.googleapis.com/auth/calendar'
      authorization.code = params[:code]
      authorization.redirect_uri = "postmessage"
      authorization.fetch_access_token!

      access_token = authorization.access_token

      token = decode_id_token(authorization.id_token, client_secrets.client_id)
      render json: 'oauth auth failed', status: 401 if not token

      uid = token["sub"]
      email = token["email"]
      user = User.find_or_create_by(uid: uid) do |user|
        user.email = email
        user.access_token = access_token
      end

      # using Fred Guest's stateless API strategy
      # http://fredguest.com/2015/03/06/building-a-stateless-rails-api-with-react-and-twitter-oauth/
      # adversaries cannot forge a jwt without the secret.  jwt are 
      # signatures, not encryptions, meaning jwt are signed non-sensitive data 
      # unique to a user (in this case, google plus id)
      jwt = JWT.encode({uid: user.uid, exp: 1.day.from_now.to_i}, Rails.application.secrets.secret_key_base)
      
      # TODO should dry this up a bit by using a serializer 
      render json: { jwt: jwt, user: user }
    else
      render json: 'oauth auth failed', status: 401
    end
  end

  private

    def get_api_client
      data = {
        "web" => {
          client_id: Figaro.env.client_id,
          auth_uri: Figaro.env.auth_uri,
          token_uri: Figaro.env.token_uri,
          auth_provider_x509_cert_url: Figaro.env.auth_provider_x509_cert_url,
          client_secret: Figaro.env.client_secret,
          javascript_origins: Figaro.env.javascript_origins.split(" ")
        }
      }
      Google::APIClient::ClientSecrets.new(data)
    end

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