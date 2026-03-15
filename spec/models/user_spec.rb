require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User validation" do
    subject { user }
    let(:user) { build(:user) }

    context "when email is null" do
      let(:user) { build(:user, email: nil) }
      it { is_expected.not_to be_valid }
    end

    context "when password is null" do
      let(:user) { build(:user, password: nil) }
      it { is_expected.not_to be_valid }
    end
  end
end
