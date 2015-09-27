class AddGcalIdToCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :gcal_id, :string
  end
end
