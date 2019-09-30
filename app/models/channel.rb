class Channel < ApplicationRecord
  belongs_to :user
  has_secure_token :token_channel
  before_create :set_token
  validates :content, numericality: { only_integer: true }
  validates :name, presence: true
  validates :description, presence:true
  validates :content, presence:true
  private
        def set_token
          self.token_channel=generate_token
        end

        def generate_token
          loop do
            token = SecureRandom.hex(10)
            break token unless Channel.where(token_channel:token).exists?
          end
        end
end