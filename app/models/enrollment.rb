class Enrollment < ApplicationRecord
  belongs_to :appointment
  belongs_to :dog

  enum :status, { active: 0, waitlisted: 1, cancelled: 2 }

  validates :appointment, :dog, :status, presence: true
  validates :appointment_id, uniqueness: { scope: :dog_id }
  validates :waitlist_position, numericality: { greater_than: 0 }, allow_nil: true

  scope :recent, -> { order(created_at: :desc) }
end
