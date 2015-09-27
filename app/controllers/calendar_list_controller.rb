class CalendarListController < BaseApiController
  before_action :authenticate_request, only: [:index]

  def index
    if @current_user.calendar_list
      render json: @current_user.calendar_list
    else
      @current_user.create_calendar_list()
    end
  end
end
