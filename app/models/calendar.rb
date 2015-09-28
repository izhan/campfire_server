class Calendar < ActiveRecord::Base
  belongs_to :calendar_list

  validates :gcal_id, presence: true, uniqueness: true

  def sync!(access_token)
    if self.sync_token
      # in the future, we can continue using this token to
      # continuously update a user's data
      return 
    else
      initial_sync(access_token)
    end

    self.save
    self
  end

  def synced?
    self.sync_token
  end

  private
    def initial_sync(access_token)
      client = Google::APIClient.new(
        application_name: "Campfire",
        application_version: "0.0.1"
      )
      client.authorization.access_token = access_token
      service = client.discovered_api('calendar', 'v3')
      events = []
      page_token = nil
      sync_token = nil

      loop do
        response = client.execute(
          :api_method => service.events.list,
          :parameters => {
            calendarId: self.gcal_id,
            timeMin: (Time.now - 6.month).iso8601,
            timeMax: (Time.now() + 6.month).iso8601,
            pageToken: page_token,
            singleEvents: true
          },
          :headers => {'Content-Type' => 'application/json'}
        )
        events += response.data.items
        page_token = response.data.next_page_token
        sync_token = response.data.next_sync_token
        break unless page_token
      end

      self.json_data = events.to_json
      self.sync_token = sync_token
    end
end
