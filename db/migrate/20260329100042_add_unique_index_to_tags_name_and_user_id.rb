class AddUniqueIndexToTagsNameAndUserId < ActiveRecord::Migration[8.1]
  def change
    add_index :tags, [:name, :user_id], unique: true
  end
end
