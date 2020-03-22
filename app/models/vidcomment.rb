class Vidcomment < ApplicationRecord
  belongs_to :user
  belongs_to :video
  validates :comment, presence: true
  has_many :videoreplies, dependent: :destroy

end
