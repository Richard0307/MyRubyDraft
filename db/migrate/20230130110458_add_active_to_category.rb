class AddActiveToCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :active, :boolean, default: true
  end
end
