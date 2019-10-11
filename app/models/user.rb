class User < ApplicationRecord
  has_secure_token
   has_one_attached :avatar
        has_secure_password
        after_initialize :set_defaults, unless: :persisted?
        before_create :set_token
        def set_defaults
            self.isAdmin = false
            self.suspended = false
            self.avatar.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: 'default.png' , content_type: "image/png")
          end
            has_many :channels, dependent: :destroy
            has_many :subscriptions, dependent: :destroy
            has_many :podcasts, dependent: :destroy
            has_many :podcasthistories, dependent: :destroy
            has_many :videos, dependent: :destroy
            has_many :videohistories, dependent: :destroy
            has_many :vidcomments, dependent: :destroy
            has_many :podcomments, dependent: :destroy
            has_many :videoreplies, dependent: :destroy
            has_many :podcastreplies, dependent: :destroy
            has_many :report_podcasts, dependent: :destroy
            has_many :report_videos, dependent: :destroy
            has_many :podcast_bookmarks, dependent: :destroy
            has_many :video_bookmarks, dependent: :destroy

            validates :email, presence: true, uniqueness: true
            validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
            validates :password,
                    length: { minimum: 6 },
                    if: -> { new_record? || !password.nil? }
            validates_presence_of :name, presence: true
            validates :avatar, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
        private
        def set_token
          self.token=generate_token
        end

        def generate_token
          loop do
            token = SecureRandom.hex(10)
            break token unless User.where(token:token).exists?
          end
        end
end
