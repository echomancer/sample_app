class Tag < ActiveRecord::Base
  has_many :hash_tags
  has_many :microposts, through: :hash_tags

  # create a custom to string method for tags
  def to_s
    name
  end

  # a feed of microposts with a certain tag
  def feed
    microposts
  end
end
