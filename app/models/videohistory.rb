class Videohistory < ApplicationRecord
  belongs_to :user
  belongs_to :video
  after_initialize :set_defaults, unless: :persisted?

  def set_defaults 
   self.viewed=1
  end
end
