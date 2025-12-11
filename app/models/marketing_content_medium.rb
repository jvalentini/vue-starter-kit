class MarketingContentMedium < ApplicationRecord
  belongs_to :marketing_content
  belongs_to :session_media

  validates :session_media_id, uniqueness: { scope: :marketing_content_id }
end
