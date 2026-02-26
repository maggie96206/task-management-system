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
        select "1 - 高", from: "優先度"
        select "進行中", from: "狀態"
        click_button "送出任務"
      end

      it { is_expected.to have_content "新標題" }
      it { is_expected.to have_content "更新後的內容" }
      it { is_expected.to have_content "2026-02-21 10:00" }
      it { is_expected.to have_content "2026-02-21 18:00" }
      it { is_expected.to have_content "1" }
      it { is_expected.to have_content "1" }
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

  describe "Task sorting" do
    let!(:old_task) { create(:task, title: "舊任務", created_at: 1.day.ago) }
    let!(:new_task) { create(:task, title: "新任務", created_at: Time.zone.now) }

    before { visit tasks_path }

    subject { all('.task-title').map(&:text) }
    it { is_expected.to eq [ "新任務", "舊任務" ] }
  end
end
