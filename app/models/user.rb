class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email,
            presence:   true,
            length:     { maximum: 100 },
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  before_save { email.downcase! } # also works --> { self.email = email.downcase }

  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }
end
