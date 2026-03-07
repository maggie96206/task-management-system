class AddIndexToTasksTitleAndStatus < ActiveRecord::Migration[8.1]
  def change
    add_index :tasks, :title
    add_index :tasks, :status
  end
end
