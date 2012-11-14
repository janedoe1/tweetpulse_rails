class Tweet < ActiveRecord::Base
  attr_accessible :tweet_id, :text, :twitter_user_id, :reply_count, :tweeted_at,:created_at
  
  belongs_to :search
  belongs_to :twitter_user
  has_one :sentiment
  has_many :retweets
  
  scope :positive, includes(:sentiment).where("sentiment.label=?", "pos")
  scope :negative, where(:is_enabled => true, :is_archived => false)
  scope :neutral, where(:is_enabled => true, :is_archived => false)
  
  def get_data current_user
    tweet = current_user.twitter.status(self.tweet_id, :include_entities => true)
    {:retweeters_count => tweet.retweeters_count,
     :repliers_count   => tweet.repliers_count,
     :followers_count  => tweet.user.followers_count,
     :friends_count    => tweet.user.friends_count,
     :retweets         => current_user.twitter.retweets(self.tweet_id)}
  end
  
  def get_retweets
    # search retweets using associated terms
	client = Twitter::Client.new
    client.retweets(self.tweet_id, :count => 29).map do |status|
      t = TwitterUser.create(:user_id        => status.user.id,
                             :handle         => status.user.name,
                             :follower_count => status.user.followers_count,
                             :friend_count   => status.user.friends_count,
                             :location       => status.user.location)
      retweet = self.retweets.create(:tweet_id => status.user.id,
                                 :twitter_user_id => t.id)
      #if status.retweet_count > 0
        # get the retweets
      # => end
    end
    self.retweets
  end

	
  def to_json
    data = {:nodes => [], :links => []}
    # set root node
    data[:nodes].push({:name => self.twitter_user.handle, :size => normalize(max_node_size), :color => 'white'}) 
    self.retweets.map {|retweet| data[:nodes].push({:name => "@" + retweet.twitter_user.handle, :size =>10 , :color => 'black', :tweet_tooltip => Rails.application.routes.url_helpers.tweet_tooltip_path(retweet)})}
    self.retweets.map.with_index {|retweet, index| data[:links].push({:source => 0, :target => index+1, :value => index, :size => retweet.twitter_user.common_followers(retweet.tweet.twitter_user),:length=> Time.now-retweet.created_at})}
	
	#:size => normalize(retweet.twitter_user.common_followers(retweet.tweet.twitter_user)),length=> normalize(retweet.created_at-Time.now)})}
	#normalize(retweet.twitter_user.follower_count)
    Rails.logger.info data
    data.to_json
  end
  
  def normalize val
    unless min_node_size == max_node_size
      xmin = min_node_size
      xmax = max_node_size
      norm_min = 10
      norm_max = 30
      xrange = xmax-xmin
      norm_range = norm_max-norm_min
      (val-xmin).to_f * (norm_max.to_f - norm_min.to_f) / (xmax.to_f - xmin.to_f) + norm_min
    else
      10
    end
    #y = 1 + (x-A)*(10-1)/(B-A)
    #norm_min + (val-xmin) * (norm_range.to_f / xrange)
  end
  
  def user_node_size
    #self.retweets.first.twitter_user.follower_count
  end
  
  def min_node_size
    #self.retweets.map {|t| t.twitter_user.follower_count}.min
    100
  end
  
  def max_node_size
    #self.retweets.map {|t| t.twitter_user.follower_count}.max
    200
  end
  
end
