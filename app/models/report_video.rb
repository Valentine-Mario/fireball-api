class ReportVideo < ApplicationRecord
  belongs_to :user
  belongs_to :video
  validates :report, presence: true

end
