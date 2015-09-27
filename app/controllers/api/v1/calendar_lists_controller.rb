class Api::V1::CalendarListsController < BaseApiController
  before_action :authenticate_request

  def index
    if !@current_user.calendar_list
      @current_user.create_calendar_list()
    end

    render json: @current_user.calendar_list.json_data
  end
end
