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

  scope :by_title, ->(title) { where("title iLIKE ?", "%#{title}%") if title.present? }

  scope :by_status, ->(status) { where(status: status) if status.present? }

  # 狀態
  enum :status, { pending: 0, in_progress: 1, completed: 2 }, default: :pending

  def human_status
    I18n.t("enums.task.status.#{status}")
  end

  # 優先度
  enum :priority, { low: 3, normal: 2, high: 1 }, default: :low

  def human_priority
    I18n.t("enums.task.priority.#{priority}")
  end

  private

  def end_at_cannot_be_before_start_at
    if end_at.present? && start_at.present? && end_at < start_at
      errors.add(:end_at, I18n.t("activerecord.errors.models.task.attributes.end_at.before_start_at"))
    end
  end
end
