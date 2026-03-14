class AssignTasksToDefaultUser < ActiveRecord::Migration[8.1]
  def up
    # 1. 建立或找到一個預設使用者
    default_user = User.find_or_create_by!(email: "admin@example.com") do |u|
      u.name = "Admin"
    end

    # 2. 將所有 user_id 為空的任務指向他
    Task.where(user_id: nil).update_all(user_id: default_user.id)

    # 3. 此時才可以安全地加上限制，防止未來出現孤兒任務
    change_column_null :tasks, :user_id, false
  end

  def down
    change_column_null :tasks, :user_id, true
  end
end
