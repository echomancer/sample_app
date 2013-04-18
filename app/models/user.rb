class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

	before_save :sanatize
	before_save :create_remember_token
	validates :name, presence: true, length: {maximum: 50}
  VALID_USERNAME_REGEX = /\A[A-Za-z0-9_-]+\z/
  validates :username, presence: true, length: {minimum: 5, maximum: 20},
          format: {with: VALID_USERNAME_REGEX}, uniqueness: { case_sensitive: true}
 	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i  
 	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
 					uniqueness: { case_sensitive: false}
 	has_secure_password
 	validates :password_confirmation, presence: true
 	validates :password, length: { minimum: 6}
  
  # The name visible depending on nameshow
  def show
    if self.nameshow
      return full_name
    else
      return "@" + self.username
    end
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

 	private

 		def create_remember_token
 			self.remember_token = SecureRandom.urlsafe_base64
 		end

    # Sanatize a gmail email address (remove dots and +label)
    def sanatize
      # Go ahead and downcase the email
      self.email = email.downcase
      # Check to see if it's a gmail address
      if /(@gmail.com)/.match(self.email)
        # Split at @  to get first part of email
        parts = email.split(/@/)
        # Take out the + tagged part
        firstpart = parts.first.split(/\+/)
        # Remove all the dots
        first = firstpart.first.gsub(/\./, "")
        # Save back as a normal gmail address
        self.email = first + "@" + parts.last
      end
    end

      # Return a formatted username and fullname(if  added)
    def full_name
      return "(" + self.name + ")@" + self.username
    end
end
