class Video < ApplicationRecord
  belongs_to :channel
  belongs_to :user
  has_secure_token
  before_create :set_token
  validates :description, presence:true
  validates :title, presence:true
  after_initialize :set_defaults, unless: :persisted?
  has_one_attached :vid
  validates :vid, attached: true , content_type: ['video/mp4', 'video/3gpp', 'video/x-msvideo', 'video/x-flv', 'video/x-matroska', 'video/quicktime']
  has_many :videohistories, dependent: :destroy
  has_many :vidcomments, dependent: :destroy
  has_many :report_videos, dependent: :destroy
  has_many :video_bookmarks, dependent: :destroy
  has_many :video_notifications, dependent: :destroy


  
  def set_defaults 
    self.suspended = false
    self.views=0
  end
private
      def set_token
        self.token=generate_token
      end

      def generate_token
        loop do
          token = SecureRandom.hex(10)
          break token unless Video.where(token:token).exists?
        end
      end
end
