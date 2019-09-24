class User < ApplicationRecord
        has_one_attached :avatar
        has_secure_password
        after_initialize :set_defaults, unless: :persisted?
        def set_defaults
            self.isAdmin = false
            self.suspended = false
            self.avatar.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: 'default.png' , content_type: "image/png")
          end
            validates :email, presence: true, uniqueness: true
            validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
            validates :password,
                    length: { minimum: 6 },
                    if: -> { new_record? || !password.nil? }
            validates_presence_of :name 
end
