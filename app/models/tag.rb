class Tag < ActiveRecord::Base
	has_many :taggings
	has_many :microposts, through: :taggings
end
