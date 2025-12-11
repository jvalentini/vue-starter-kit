class InvoiceLineItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :appointment, optional: true

  validates :description, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, :total, numericality: { greater_than_or_equal_to: 0 }

  before_validation :compute_total

  private

  def compute_total
    return if unit_price.blank? || quantity.blank?

    self.total ||= unit_price.to_d * quantity
  end
end
