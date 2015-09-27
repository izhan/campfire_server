class CreateCalendarLists < ActiveRecord::Migration
  def change
    create_table :calendar_lists do |t|
      t.column :json_data, :text

      t.timestamps null: false
    end
  end
end
