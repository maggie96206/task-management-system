class User < ApplicationRecord
  before_destroy :ensure_at_least_one_admin_remains
  has_many :tags, dependent: :destroy

  has_secure_password
  validates :password, length: { minimum: 3 }, allow_blank: true

  has_many :tasks, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  private

  def ensure_at_least_one_admin_remains
    # 如果要刪除的人是 admin，且資料庫剩不到 2 個 admin
    if admin? && User.where(admin: true).count <= 1
      errors.add(:base, :at_least_one_admin)
      throw :abort
    end
  end
end
