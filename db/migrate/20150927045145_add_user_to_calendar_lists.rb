class AddUserToCalendarLists < ActiveRecord::Migration
  def change
    add_reference :calendar_lists, :user, index: true
    add_foreign_key :calendar_lists, :users
  end
end
