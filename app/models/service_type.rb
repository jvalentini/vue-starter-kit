class ServiceType < ApplicationRecord
  has_many :appointments, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :duration_minutes, numericality: { greater_than: 0 }
  validates :capacity, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }
  scope :recent, -> { order(updated_at: :desc) }
end
