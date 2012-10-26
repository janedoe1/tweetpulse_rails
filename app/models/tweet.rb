class Tweet < ActiveRecord::Base
  attr_accessible :tweet_id, :from_user, :text
  
  belongs_to :term
  
  def get_data current_user
    tweet = current_user.twitter.status(self.tweet_id)
    {:retweeters_count => tweet.retweeters_count,
     :repliers_count   => tweet.repliers_count,
     :followers_count  => tweet.user.followers_count,
     :friends_count    => tweet.user.friends_count,
     :retweeters       => tweet.retweeters}
  end
end
