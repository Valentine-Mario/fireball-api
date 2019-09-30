class Channel < ApplicationRecord
  belongs_to :user
  has_secure_token
  before_create :set_token
  validates :content, numericality: { only_integer: true }
  validates :name, presence: true
  validates :description, presence:true
  validates :content, presence:true
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
