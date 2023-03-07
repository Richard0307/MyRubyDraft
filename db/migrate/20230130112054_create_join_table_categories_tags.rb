class CreateJoinTableCategoriesTags < ActiveRecord::Migration[7.0]
  def change
    create_join_table :categories, :tags do |t|
      t.index [:category_id, :tag_id]
      t.index [:tag_id, :category_id]
    end
  end
end
