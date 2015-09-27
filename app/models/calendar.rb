class Calendar < ActiveRecord::Base
  belongs_to :calendar_list

  validates :gcal_id, presence: true, uniqueness: true

  def sync!(access_token)
    if self.json_data
      return # TODO resync with server using sync token
    else
      self.json_data = fetch_json(access_token, gcal_id)
      self.save
    end
  end

  private
    def fetch_json(access_token, gcal_id)
      puts "initial calendar sync"
      client = Google::APIClient.new(
        application_name: "Campfire",
        application_version: "0.0.1"
      )
      client.authorization.access_token = access_token
      service = client.discovered_api('calendar', 'v3')
      events = []
      page_token = nil

      loop do
        response = client.execute(
          :api_method => service.events.list,
          :parameters => {
            calendarId: gcal_id,
            timeMin: (Time.now - 6.month).iso8601,
            timeMax: (Time.now() + 6.month).iso8601,
            pageToken: page_token,
            singleEvents: true
          },
          :headers => {'Content-Type' => 'application/json'}
        )
        events += response.data.items.to_json
        page_token = response.data.page_token
        break unless page_token
      end

      events.to_json
    end
end
