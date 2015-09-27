class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.references :calendar_list, index: true
      t.text :json_data

      t.timestamps null: false
    end
    add_foreign_key :calendars, :calendar_lists
  end
end
