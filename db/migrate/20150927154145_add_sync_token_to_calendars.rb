class AddSyncTokenToCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :sync_token, :string
  end
end
