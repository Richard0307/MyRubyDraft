class CreateMockInterviews < ActiveRecord::Migration[7.0]
  def change
    create_table :mock_interviews do |t|

      t.timestamps
    end
  end
end
