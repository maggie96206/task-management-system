require "rails_helper"

RSpec.feature "Tag Management", type: :feature do
  subject { page }

  let(:user) { create(:user, email: "test@example.com", password: "password") }

  before do
    visit login_path
    fill_in "電子信箱", with: user.email
    fill_in "密碼", with: user.password
    click_button "登入"
  end

  describe "Tag CRUD operations" do
    context "when creating a tag" do
      before do
        visit tags_path
        click_link "+ 新增標籤"
        fill_in "標籤名稱", with: "新標籤"
        click_button "確認"
      end

      it { is_expected.to have_content "新標籤" }
    end

    context "when editing a tag" do
      let!(:tag) { create(:tag, name: "舊標籤", user: user) }

      before do
        visit edit_tag_path(tag)
        fill_in "標籤名稱", with: "新標籤名稱"
        click_button "確認"
      end

      it { is_expected.to have_content "標籤更新成功" }
      it { is_expected.to have_content "新標籤名稱" }
      it { is_expected.not_to have_content "舊標籤" }
    end

    context "when deleting a tag" do
      let!(:tag) { create(:tag, name: "要刪除的標籤", user: user) }

      before do
        visit tags_path
        click_link "刪除"
      end

      it { is_expected.to have_current_path tags_path }
      it { is_expected.not_to have_content "要刪除的標籤" }
    end
  end

  describe "Task with tag" do
    let!(:tag) { create(:tag, name: "工作標籤", user: user) }

    context "when task has a tag, it shows in task list" do
      let!(:task) { create(:task, title: "標籤任務", user: user, tags: [tag]) }

      before { visit tasks_path }

      it { is_expected.to have_content "工作標籤" }
    end

    context "when searching tasks by tag" do
      let!(:task_with_tag) { create(:task, title: "有標籤的任務", user: user, tags: [tag]) }
      let!(:task_without_tag) { create(:task, title: "無標籤的任務", user: user) }

      before do
        visit tasks_path
        select "工作標籤", from: "tag_id"
        click_button "搜尋"
      end

      it { is_expected.to have_content "有標籤的任務" }
      it { is_expected.not_to have_content "無標籤的任務" }
    end
  end
end
