class Videoreply < ApplicationRecord
  belongs_to :user
  belongs_to :vidcomment
  validates :comment, presence: true

end
