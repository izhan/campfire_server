class CalendarListController < BaseApiController
  before_action :authenticate_request, only: [:index]

  def index
    @current_user
  end
end
