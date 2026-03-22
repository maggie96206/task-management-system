require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User associations" do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe "User validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_length_of(:password).is_at_least(3) }
    it { is_expected.to have_secure_password }
  end

  describe "#ensure_at_least_one_admin_remains" do
    context "when deleting the last admin" do
      let!(:last_admin) { create(:user, :admin) }

      it "does not allow deletion and adds an error" do
        expect { last_admin.destroy }.not_to change(User, :count)
        expect(last_admin.errors[:base]).to include("至少要留一個管理員")
      end
    end
  end
end
