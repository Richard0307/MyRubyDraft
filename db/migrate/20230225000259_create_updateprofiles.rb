class CreateUpdateprofiles < ActiveRecord::Migration[7.0]
  def change
    create_table :updateprofiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :student_status
      t.string :reason_for_withdrawing
      t.string :location
      t.string :course
      t.string :sector

      t.timestamps
    end
  end
end
