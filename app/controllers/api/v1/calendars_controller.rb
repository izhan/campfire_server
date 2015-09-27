class Api::V1::CalendarsController < BaseApiController
  before_action :authenticate_request

  # not the right path, but oh well for now
  def index
    calendar_list = @current_user.calendar_list
    calendar = calendar_list.find_or_create_by(gcal_id: params[:gcal_id])
    calendar.sync!(@current_user.access_token) if not calendar.synced?

    render json: calendar.json_data
  end
end
