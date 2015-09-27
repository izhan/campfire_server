class Api::V1::CalendarsController < BaseApiController
  before_action :authenticate_request

  # not the right path, but oh well for now
  def index
    verify_owner(params[:gcal_id])

    calendar_list = @current_user.calendar_list
    calendar = calendar_list.calendars.find_or_create_by(gcal_id: params[:gcal_id])
    calendar.sync!(@current_user.access_token) if not calendar.synced?

    render json: calendar.json_data
  end

  private
    def does_own_calendar?(id)
      @current_user.calendar_list.calendars.exists?(gcal_id: id)
    end

    # make sure user actually owns the calendar
    def verify_owner(id)
      unless does_own_calendar?
        render json: 'unauthorized calendar access', status: 401
      end
    end
end
