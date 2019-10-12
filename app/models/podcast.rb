class Podcast < ApplicationRecord
  belongs_to :channel
  belongs_to :user 
  has_secure_token
  before_create :set_token
  validates :desciption, presence:true
  validates :title, presence:true
  after_initialize :set_defaults, unless: :persisted?
  has_one_attached :pod
  validates :pod, attached: true , content_type: ['audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio', 'audio/x-wav', 'audio/x-wave']
  has_many :podcasthistories, dependent: :destroy
  has_many :podcomments, dependent: :destroy
  has_many :report_podcasts, dependent: :destroy
  has_many :podcast_bookmarks, dependent: :destroy
  has_many :podcast_notifications, dependent: :destroy


  def set_defaults 
      self.suspended = false
      self.listens=0
    end
  private
        def set_token
          self.token=generate_token
        end

        def generate_token
          loop do
            token = SecureRandom.hex(10)
            break token unless Podcast.where(token:token).exists?
          end
        end
end
