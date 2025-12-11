class SessionMedia < ApplicationRecord
  belongs_to :appointment
  belongs_to :dog, optional: true

  has_many :marketing_content_media, dependent: :destroy
  has_many :marketing_contents, through: :marketing_content_media

  validates :media_type, presence: true

  scope :featured, -> { where(featured: true) }
  scope :recent, -> { order(taken_at: :desc, created_at: :desc) }
end
