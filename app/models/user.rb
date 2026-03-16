class User < ApplicationRecord
  before_destroy :ensure_at_least_one_admin_remains
  has_secure_password

  has_many :tasks, dependent: :destroy
  validates :email, presence: true, uniqueness: true

  private

  def ensure_at_least_one_admin_remains
    # 如果要刪除的人是 admin，且資料庫剩不到 2 個 admin
    if admin? && User.where(admin: true).count <= 1
      errors.add(:base, "至少要留一個管理員")
      throw :abort
    end
  end
end
