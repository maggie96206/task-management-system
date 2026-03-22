require "rails_helper"

RSpec.feature "Admin User Management", type: :feature do
  subject { page }

  let(:admin) { create(:user, :admin, name: "Admin", email: "admin@example.com", password: "password") }
  let!(:target_user) { create(:user, name: "Old User", email: "old@example.com") }

  before do
    visit login_path
    fill_in "電子信箱", with: admin.email
    fill_in "密碼", with: admin.password
    click_button "登入"
  end

  describe "User CRUD operations" do
    before { visit admin_users_path }

    context "when viewing a user's tasks" do
      let!(:user_task) { create(:task, title: "Target User Task", user: target_user) }

      before do
        within "tr", text: target_user.name do
          click_link "檢視"
        end
      end

      it { is_expected.to have_content "#{target_user.name}" }
      it { is_expected.to have_content "Target User Task" }
    end

    context "when creating a new user" do
      before do
        click_link "新增使用者"
        fill_in "名稱", with: "New Employee"
        fill_in "電子信箱", with: "new@example.com"
        fill_in "密碼", with: "password123"
        check "設為管理員"
        click_button "確認"
      end

      it { is_expected.to have_content "New Employee" }
      it { is_expected.to have_content "管理員" }
    end

    context "when editing a user's role" do
      before do
        within "tr", text: target_user.name do
          click_link "編輯"
        end

        check "設為管理員"
        fill_in "密碼", with: ""
        click_button "確認"
      end

      it { is_expected.to have_content "使用者資料更新成功" }
      it { expect(target_user.reload.admin).to be_truthy }
      it { is_expected.to have_content "管理員" }
    end

    context "when deleting a user" do
      let!(:another_user) { create(:user, name: "To Be Deleted") }

      before do
        visit admin_users_path
        within "tr", text: another_user.name do
          click_link "刪除"
        end
      end

      it { is_expected.to have_current_path admin_users_path }
      it { is_expected.not_to have_content "To Be Deleted" }
    end
  end

  describe "Security check" do
    context "when a non-admin user tries to access admin pages" do
      let(:normal_user) { create(:user, admin: false) }

      before do
        # 換成一般人登入
        click_link "登出"
        visit login_path
        fill_in "電子信箱", with: normal_user.email
        fill_in "密碼", with: normal_user.password
        click_button "登入"
        visit admin_users_path
      end

      it { is_expected.to have_current_path root_path }
      it { is_expected.to have_content "您沒有管理權限！" }
    end
  end
end
