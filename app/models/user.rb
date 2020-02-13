class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  validates :name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :email,
            presence:   true,
            length:     { minimum: 2, maximum: 100 },
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  before_save { email.downcase! } # also works --> { self.email = email.downcase }
end
