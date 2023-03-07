class CreateMyapplications < ActiveRecord::Migration[7.0]
  def change
    create_table :myapplications do |t|
      t.string :company
      t.string :role
      t.date :application_deadline
      t.string :status
      t.date :date_applied
      t.string :location

      t.timestamps
    end
  end
end
