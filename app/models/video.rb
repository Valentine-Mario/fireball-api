class Video < ApplicationRecord
  belongs_to :channel
  belongs_to :user
  has_secure_token
  validates :description, presence:true
  validates :title, presence:true
  has_one_attached :vid
  validates :vid, attached: true , content_type: ['video/mp4', 'video/3gpp', 'video/x-msvideo', 'video/x-flv', 'video/x-matroska', 'video/quicktime']
  validates :vid, size:{less_than: 100.megabyte}
  has_many :videohistories, dependent: :destroy
  has_many :vidcomments, dependent: :destroy
  has_many :report_videos, dependent: :destroy
  has_many :video_bookmarks, dependent: :destroy
  has_many :video_notifications, dependent: :destroy
  has_secure_token
end
