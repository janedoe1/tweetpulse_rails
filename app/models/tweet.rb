class Tweet < ActiveRecord::Base
  attr_accessible :tweet_id, :text, :twitter_user_id, :reply_count, :tweeted_at
  
  belongs_to :search
  belongs_to :twitter_user
  has_one :sentiment
  
  def get_data current_user
    tweet = current_user.twitter.status(self.tweet_id, :include_entities => true)
    {:retweeters_count => tweet.retweeters_count,
     :repliers_count   => tweet.repliers_count,
     :followers_count  => tweet.user.followers_count,
     :friends_count    => tweet.user.friends_count,
     :retweets         => current_user.twitter.retweets(self.tweet_id)}
  end
end
