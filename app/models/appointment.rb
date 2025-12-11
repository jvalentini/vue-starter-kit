class Appointment < ApplicationRecord
  belongs_to :client
  belongs_to :dog, optional: true
  belongs_to :service_type

  has_many :enrollments, dependent: :destroy
  has_many :invoice_line_items, dependent: :nullify
  has_many :session_media, dependent: :destroy
  has_many :report_cards, dependent: :destroy

  enum :status, { scheduled: 0, completed: 1, cancelled: 2, no_show: 3 }

  validates :starts_at, :ends_at, :client, :service_type, presence: true
  validate :ends_after_starts

  scope :active, -> { where.not(status: %i[cancelled no_show]) }
  scope :recent, -> { order(starts_at: :desc) }

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?

    errors.add(:ends_at, "must be after the start time") if ends_at <= starts_at
  end
end
