# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


puts "正在準備seed資料"
user = User.find_or_create_by!(email: "test@example.com") do |u|
  u.name = "Test User"
end
puts "使用者已就緒: #{user.name} (#{user.email})"

orphaned_tasks = Task.where(user_id: nil)
if orphaned_tasks.any?
  count = orphaned_tasks.count
  orphaned_tasks.update_all(user_id: user.id)
  puts "舊資料維護：已將 #{count} 個孤兒任務指派給 #{user.name}"
end

if Task.count < 50
  puts "正在產生1000筆測試任務"
  1000.times do
    Task.create!(
      title: Faker::Job.title,
      content: Faker::Lorem.sentence,
      status: [ 0, 1, 2 ].sample,
      end_at: Time.now + rand(1..10).days,
      user: user
    )
  end
  puts "1000筆任務建立完成"
else
  puts "已有足夠任務，跳過產生測試資料"
end
