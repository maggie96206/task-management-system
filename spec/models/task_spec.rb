require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "Task validation" do
    subject { task }
    let(:task) { build(:task) }
    it { is_expected.to have_many(:tags).through(:task_tags) }

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

  describe "Search by tag" do
    let!(:tag) { create(:tag) }
    let!(:task_with_tag) { create(:task, tags: [tag]) }
    let!(:task_without_tag) { create(:task) }

    subject { Task.by_tag(tag.id) }
    it { is_expected.to include(task_with_tag) }
    it { is_expected.not_to include(task_without_tag) }
  end
end
