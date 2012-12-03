class Retweet < ActiveRecord::Base
  attr_accessible :tweet_id, :twitter_user_id, :tweeted_at
  
  belongs_to :tweet
  belongs_to :twitter_user
  
end
