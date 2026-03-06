class Task < ApplicationRecord
  # 標題不可空白
  validates :title, presence: true

  # 結束時間不能早於開始時間
  validate :end_at_cannot_be_before_start_at

  scope :sorted_by, ->(sort_option) {
    case sort_option
    when "end_at"
      order(end_at: :asc)
    else
      order(created_at: :desc)
    end
  }

  private

  def end_at_cannot_be_before_start_at
    if end_at.present? && start_at.present? && end_at < start_at
      errors.add(:end_at, I18n.t("activerecord.errors.models.task.attributes.end_at.before_start_at"))
    end
  end
end
