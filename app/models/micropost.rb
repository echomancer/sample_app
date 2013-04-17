class Micropost < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings

  # Functions to help with adding tags
  def self.tagged_with(name)
    Tag.find_by_name!(name).microposts
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("tags.id")
  end
  
  def tag_list
    tags.map(&:name).join(", ")
  end
  
  def tag_list=(names)
    tag_names = names.split(",").collect{ |s| s.strip.downcase }.uniq
    dog_tags = tag_names.collect{ |name| Tag.find_or_create_by(name: name)}
    self.tags = dog_tags

    # Alternate create method
    #self.tags = names.split(",").map do |n|
    #  Tag.where(name: n.strip).first_or_create!
    #end
  end
  # end of Tagging functions

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
end

