class Podcast < ApplicationRecord
  belongs_to :channel
  belongs_to :user 
  has_secure_token
  before_create :set_token
  validates :desciption, presence:true
  validates :title, presence:true
  after_initialize :set_defaults, unless: :persisted?
  has_one_attached :pod
  validates :pod, attached: true, content_type: ['audio/mp3', 'audio/wave', 'audio/mpeg', 'audio/ogg']

  def set_defaults 
      self.suspended = false
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
