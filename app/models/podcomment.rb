class Podcomment < ApplicationRecord
  belongs_to :user
  belongs_to :podcast
  validates :comment, presence: true
  has_many :podcastreplies, dependent: :destroy

end
