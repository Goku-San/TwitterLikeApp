class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_password_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: :follower_id,
                                  inverse_of:  :follower,
                                  dependent:   :destroy

  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: :followed_id,
                                   inverse_of:  :followed,
                                   dependent:   :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships

  validates :name, presence: true, length: { allow_blank: true, minimum: 2, maximum: 50 }
  validates :email,
            presence:   true,
            length:     { maximum: 100 },
            format:     { allow_blank: true, with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  before_create :create_activation_digest

  before_save { email.downcase! } # also works --> { self.email = email.downcase }

  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  scope :activated_users, -> { where activated: true }

  # Returns the hash digest of the given string.
  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

    BCrypt::Password.create string, cost: cost
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token

    update_attribute :remember_digest, User.digest(remember_token)
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribut, token
    digest = send "#{attribut}_digest"

    return if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  # Forgets a user.
  def forget
    update_attribute :remember_digest, nil
  end

  # Activates an account.
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_password_reset_digest
    self.reset_password_token = User.new_token

    update_columns reset_password_digest: User.digest(reset_password_token),
                   reset_sent_at:         Time.zone.now
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def reset_password_expired?
    reset_sent_at < 2.hours.ago
  end

  # Returns a user's status feed
  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE  follower_id = :user_id"

    Micropost.where "user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id
  end

  # # Follows a user.
  def follow other_user
    active_relationships.create followed_id: other_user.id
  end

  # # Unfollows a user.
  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following? other_user
    following.include? other_user
  end

  private

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
