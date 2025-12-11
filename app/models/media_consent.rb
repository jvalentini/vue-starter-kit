class MediaConsent < ApplicationRecord
  belongs_to :client

  validates :client, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
