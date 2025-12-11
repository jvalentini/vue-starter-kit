class Client < ApplicationRecord
  has_many :dogs, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :enrollments, through: :appointments
  has_one :media_consent, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, length: { maximum: 32 }, allow_blank: true

  scope :active, -> { where(discarded_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def name
    "#{first_name} #{last_name}"
  end
end
