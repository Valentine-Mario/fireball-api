class ReportPodcast < ApplicationRecord
  belongs_to :user
  belongs_to :podcast
  validates :report, presence: true

end
