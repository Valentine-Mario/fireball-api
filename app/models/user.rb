class User < ApplicationRecord
        has_one_attached :avatar
    has_secure_password
    after_initialize :set_defaults, unless: :persisted?
    def set_defaults
        self.isAdmin = false
        self.suspended = false
        self.pics="https://res.cloudinary.com/school-fleep/image/upload/v1535357797/avatar-1577909_640.png"
      end
        validates :email, presence: true, uniqueness: true
        validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
        validates :password,
                length: { minimum: 6 },
                if: -> { new_record? || !password.nil? }
        validates_presence_of :name 
end
