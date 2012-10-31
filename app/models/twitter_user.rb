class TwitterUser < ActiveRecord::Base
  attr_accessible :follower_count, :friend_count, :handle, :location, :user_id

  has_many :tweets
end
