class AssignTasksToDefaultUser < ActiveRecord::Migration[8.1]
  def up
    default_user = User.find_or_create_by!(email: "admin@example.com") do |u|
      u.name = "Admin"
    end

    Task.where(user_id: nil).update_all(user_id: default_user.id)

    change_column_null :tasks, :user_id, false
  end

  def down
    change_column_null :tasks, :user_id, true
  end
end
