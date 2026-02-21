require "rails_helper"

RSpec.feature "Task Management", type: :feature do
  # 測試一開始就建立好的資料
  let!(:task) { create(:task, title: "舊任務", priority: 2, status: 0) }

  describe "Task CRUD operations" do

    context "when editing a task" do
      before do
        visit edit_task_path(task)
      end

      scenario "should be successful with all fields filled" do
        fill_in "任務標題", with: "新標題"
        fill_in "內容", with: "更新後的內容"

        # 填寫時間 (HTML5 datetime 格式)
        fill_in "開始時間", with: "2026-02-21T10:00"
        fill_in "結束時間", with: "2026-02-21T18:00"

        # 選擇下拉選單 (使用選項的文字)
        select "1 - 高", from: "優先度"
        select "進行中", from: "狀態"

        click_button "送出任務"

        # 驗證頁面內容
        expect(page).to have_content "新標題"
        expect(page).to have_content "更新後的內容"
        expect(page).to have_content "1"
        expect(page).to have_content "1"
        expect(page).to have_content "2026-02-21 10:00"
      end
    end

    context "when deleting a task" do
      scenario "should remove the task from the index list" do
        visit tasks_path

        click_link "刪除"

        # 如果有瀏覽器確認視窗 (Confirm)，Capybara 預設會自動點擊「確定」
        expect(page).to have_current_path tasks_path
        expect(page).not_to have_content "舊任務"
      end
    end
  end
end
