class Podcast < ApplicationRecord
  belongs_to :channel
  belongs_to :user 
  has_secure_token
  validates :desciption, presence:true
  validates :title, presence:true
  has_one_attached :pod
  after_initialize :set_defaults, unless: :persisted?
  validates :pod, attached: true , content_type: ['audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio', 'audio/x-wav', 'audio/x-wave']
  validates :pod, size:{less_than: 50.megabyte}
  has_many :podcasthistories, dependent: :destroy
  has_many :podcomments, dependent: :destroy
  has_many :report_podcasts, dependent: :destroy
  has_many :podcast_bookmarks, dependent: :destroy
  has_many :podcast_notifications, dependent: :destroy
  def set_defaults 
    self.suspended = false
    self.listens=0
  end
  has_secure_token

end
