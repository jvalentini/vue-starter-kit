class Invoice < ApplicationRecord
  belongs_to :client
  has_many :invoice_line_items, dependent: :destroy

  enum :status, { draft: 0, sent: 1, paid: 2, overdue: 3 }

  validates :invoice_number, presence: true, uniqueness: true
  validates :issue_date, :due_date, :status, presence: true
  validates :subtotal, :tax, :total, numericality: { greater_than_or_equal_to: 0 }
  validate :due_date_not_before_issue

  scope :active, -> { where(status: %i[draft sent]) }
  scope :recent, -> { order(issue_date: :desc) }

  private

  def due_date_not_before_issue
    return if issue_date.blank? || due_date.blank?

    errors.add(:due_date, "must be on or after the issue date") if due_date < issue_date
  end
end
