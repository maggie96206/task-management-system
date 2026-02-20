class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :content
      t.datetime :start_at
      t.datetime :end_at
      t.integer :priority, default: 3   # 設定預設值（3: 最低）
      t.integer :status, default: 0     # 設定預設值 (0: 待處理)

      t.timestamps
    end
  end
end
