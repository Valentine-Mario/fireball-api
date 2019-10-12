class VideoNotification < ApplicationRecord
  belongs_to :user
  belongs_to :video
  after_initialize :set_defaults, unless: :persisted?
  def set_defaults 
    self.viewed=false
  end
end
