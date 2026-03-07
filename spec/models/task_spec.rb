require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "Task validation" do
    subject { task }
    let(:task) { build(:task) }

    context "when title is null" do
      let(:task) { build(:task, title: nil) }
      it { is_expected.not_to be_valid }
    end

    context "when end_at is before start_at" do
      let(:task) { build(:task, start_at: Time.zone.now, end_at: 1.day.ago) }
      it { is_expected.not_to be_valid }
    end
  end

  describe "Search by title" do
    let!(:task1) { create(:task, title: "估時會議") }
    let!(:task2) { create(:task, title: "吃午餐") }

    subject { Task.by_title("估時") }
    it { is_expected.to include(task1) }
    it { is_expected.not_to include(task2) }
  end
end
