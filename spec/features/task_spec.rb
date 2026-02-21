require 'rails_helper'

RSpec.feature "Task Management", type: :feature do
  let!(:task) { create(:task, title: "舊任務") } # 先建立一筆資料

  scenario "更新任務成功" do
    visit edit_task_path(task)
    fill_in "任務標題", with: "新標題"
    click_button "送出任務"
    expect(page).to have_content "新標題"
  end

  scenario "刪除任務成功" do
    visit tasks_path
    click_link "刪除" # 或是用你按鈕的文字
    # 如果有確認視窗，Capybara 會自動處理或需要額外設定
    expect(page).not_to have_content "舊任務"
  end
end
