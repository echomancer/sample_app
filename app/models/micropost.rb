class Micropost < ActiveRecord::Base
  has_many :hash_tags
  has_many :tags, through: :hash_tags
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end

  def tag_list
    tags.join(", ")
  end


  # Create a list of all tags associated with this post from a string of tags
  def tag_list=(tags_string)
    # make a list of comma seperated tags keeping only unique ones
    tag_names = tags_string.to_s.split(",").collect{|s| s.strip.downcase }.uniq
    # Add new or found tags to be associated with this post
    new_or_found_tags = tag_names.collect{|name| Tag.find_or_create_by(name: name)}
    # Associated these tags
    self.tags = new_or_found_tags
  end
end

