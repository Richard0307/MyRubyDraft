class AddUserIdToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :user, null: false, foreign_key: true
  end
end
