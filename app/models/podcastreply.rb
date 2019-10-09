class Podcastreply < ApplicationRecord
  belongs_to :user
  belongs_to :podcomment
  validates :comment, presence: true

end
