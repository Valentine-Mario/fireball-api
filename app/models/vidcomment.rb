class Vidcomment < ApplicationRecord
  belongs_to :user
  belongs_to :podcast
  validates :comment, presence: true
end
