class Podcasthistory < ApplicationRecord
  belongs_to :user
  belongs_to :podcast
  after_initialize :set_defaults, unless: :persisted?

  def set_defaults 
   self.listens=1
  end
end
