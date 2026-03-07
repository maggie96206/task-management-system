require "rails_helper"

RSpec.feature "Task Management", type: :feature do
  subject { page }
  describe "Task CRUD operations" do
    let!(:task) { create(:task, title: "舊任務", priority: 2, status: 0) }

    context "when editing a task" do
      before do
        visit edit_task_path(task)
        fill_in "任務標題", with: "新標題"
        fill_in "內容", with: "更新後的內容"
        fill_in "開始時間", with: "2026-02-21T10:00"
        fill_in "結束時間", with: "2026-02-21T18:00"
        select "高", from: "優先度"
        select "進行中", from: "狀態"
        click_button "送出任務"
      end

      it { is_expected.to have_content "新標題" }
      it { is_expected.to have_content "更新後的內容" }
      it { is_expected.to have_content "2026-02-21 10:00" }
      it { is_expected.to have_content "2026-02-21 18:00" }
      it { is_expected.to have_content "高" }
      it { is_expected.to have_content "進行中" }
    end

    context "when deleting a task" do
      before do
        visit tasks_path
        click_link "刪除"
      end

      it { is_expected.to have_current_path tasks_path }
      it { is_expected.not_to have_content "舊任務" }
    end
  end

  describe "Task sorted by created_at" do
    let!(:old_task) { create(:task, title: "舊任務", created_at: 1.day.ago) }
    let!(:new_task) { create(:task, title: "新任務", created_at: Time.zone.now) }

    before { visit tasks_path }

    subject { all('.task-title').map(&:text) }
    it { is_expected.to eq [ "新任務", "舊任務" ] }
  end

  describe "Task sorted by end_at" do
    let!(:earlier_task) { create(:task, title: "早結束任務", end_at: 1.day.from_now) }
    let!(:later_task) { create(:task, title: "晚結束任務", end_at: 2.day.from_now) }

    before { visit tasks_path(sort: "end_at") }

    subject { all('.task-title').map(&:text) }
    it { is_expected.to eq [ "早結束任務", "晚結束任務" ] }
  end

  describe "Search task", type: :feature do
    let!(:task_target) { create(:task, title: "重要會議", status: :pending) }
    let!(:task_other) { create(:task, title: "吃午餐", status: :completed) }

    context "when search by title and selected status" do
      subject { page }

      before do
        visit tasks_path
        fill_in "搜尋任務標題", with: "會議"
        select "待處理", from: "status"
        click_button "搜尋"
      end

      it { is_expected.to have_content "重要會議" }
      it { is_expected.not_to have_content "吃午餐" }
    end
  end
end
