class AddIsStaffToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_staff, :boolean
  end
end
