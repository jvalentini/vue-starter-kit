class Dog < ApplicationRecord
  belongs_to :client
  has_many :appointments, dependent: :nullify
  has_many :enrollments, dependent: :destroy
  has_many :report_cards, dependent: :destroy
  has_many :session_media, dependent: :destroy

  validates :name, presence: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :active, -> { where(discarded_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
end
