class MarketingContent < ApplicationRecord
  enum :status, { draft: 0, scheduled: 1, published: 2 }

  has_many :marketing_content_media, dependent: :destroy
  has_many :session_media, through: :marketing_content_media

  validates :title, presence: true

  scope :active, -> { where(status: %i[scheduled published]) }
  scope :recent, -> { order(created_at: :desc) }
end
