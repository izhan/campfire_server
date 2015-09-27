require 'google/api_client'

class CalendarList < ActiveRecord::Base
  after_create :sync
  belongs_to :user
  has_many :calendars

  private

    def sync
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

      result.data.items.each do |cal|
        # allow to reuse calendar if already present
        db_cal = Calendar.find_or_create_by(gcal_id: cal["id"])
        self.calendars << db_cal
      end

      self.save
    end
end
