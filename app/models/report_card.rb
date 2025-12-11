class ReportCard < ApplicationRecord
  belongs_to :appointment, optional: true
  belongs_to :dog

  enum :status, { draft: 0, published: 1 }

  validates :report_date, presence: true
  validates :share_token, uniqueness: true, allow_nil: true
  validates :overall_score, :obedience_score, :leash_manners_score, :focus_score, :socialization_score,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }, allow_nil: true

  scope :active, -> { where(status: :published) }
  scope :recent, -> { order(report_date: :desc) }
end
