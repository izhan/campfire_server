class User < ActiveRecord::Base
  before_create :add_uid

  private
    # kind of sucks that the id is not returned to us 
    # in oauth authentication
    def fetch_user_info(access_token)
      # TODO shouldn't have to initialize this every time
      client = Google::APIClient.new(
        application_name: "Campfire",
        application_version: "0.0.1"
      )

      client.authorization.access_token = access_token
      service = client.discovered_api('plus', 'v1')
      puts "before execute"
      google_response = client.execute(
        :api_method => service.people.get,
        :parameters => { userId: "me" },
        :headers => {'Content-Type' => 'application/json'}
      )
      puts "after execute"
      JSON.parse(google_response.body)
      
    end

    def add_user_info
      user_info = fetch_user_info(self.access_token)
      self.uid = user_info["id"]
      # TODO and if they have more than one email?  is the first one always
      # the primary one?
      self.email = user_info["emails"][0]["value"]
    end
end
