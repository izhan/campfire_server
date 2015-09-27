class ApplicationController < ActionController::API
  before_action :authenticate_request, only: [:current_user]

  def current_user
    render json: { user: @current_user }
  end

  private

    # client passes in jwt stored in localstorage in headers
    # we authenticate here instead of say an UserAuthController so
    # all controllers can use this
    def authenticate_request
      begin
        uid = JWT.decode(request.headers['Authorization'], Rails.application.secrets.secret_key_base)[0]['uid']
        @current_user = User.find_by(uid: uid)
      rescue JWT::DecodeError
        render json: 'authentication failed', status: 401
      end
    end
end
