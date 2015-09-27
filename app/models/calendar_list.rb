require 'google/api_client'

class CalendarList < ActiveRecord::Base
  before_create :initial_sync
  belongs_to :user

  serialize :json_data

  private

    def initial_sync
      puts "initial sync"
      client = Google::APIClient.new(
        application_name: "Campfire",
        application_version: "0.0.1"
      )
      client.authorization.access_token = self.user.access_token
      service = client.discovered_api('calendar', 'v3')
      result = client.execute(
        :api_method => service.calendar_list.list,
        :parameters => {},
        :headers => {'Content-Type' => 'application/json'}
      )

      # calendars could paginate too, though we'll assume that
      # the calendarlist isnt that long
      self.json_data = result.data.items.to_json
    end
end
