class Channel < ApplicationRecord
  belongs_to :user
  has_secure_token :token_channel
  has_one_attached :image
  validates :image, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates :image, size:{less_than: 3.megabyte}
  validates :content, numericality: { only_integer: true }
  validates :name, presence: true
  validates :description, presence:true
  validates :content, presence:true
  has_many :subscriptions, dependent: :destroy
  has_many :podcasts, dependent: :destroy
  has_many :videos, dependent: :destroy
  
end
