class DashboardPresenter

  attr_reader :tag, :graph_min, :graph_max, :searches

  def initialize(current_user, options = {})
    @user = current_user
    @searches = current_user.searches
    @tweets = @searches.collect {|s| s.tweets}.flatten
    @sentiments = Sentiment.where("tweet_id in (?)", @tweets.map(&:id))
    @twitter_users = @searches.collect {|s| s.twitter_users}.flatten
  end
  
  def sentiment_tweet_count(label)
    @sentiments.where(:label => label).count
  end
  
  def search_tweet_counts(count=5)
    @searches.order("created_at DESC").limit(count).collect {|search| %(["#{search.label}", #{(search.tweets.count)}])}
  end
  
  def top_influencers(count=5)
    #TwitterUser.order("influence DESC").limit(count)
    TwitterUser.order("influence DESC").limit(count).collect {|twitter_user| %(["@#{twitter_user.handle}", #{(twitter_user.influence)}])}
  end
  
  def influence_vs_outreach(count=10)
    TwitterUser.order("influence DESC").limit(count).collect {|twitter_user| %([#{twitter_user.outreach}, #{(twitter_user.influence)}])}
  end
  
  def top_tweets(count=5)
    Tweet.find(:all, :select => 'tweets.*, count(retweets.id) as retweet_count',
                 :joins => 'left outer join retweets on retweets.tweet_id = tweets.id',
                 :group => 'tweets.id',
                 :order => 'retweet_count ASC').take(count)
    #@tweets.collect {|t| t.retweets.count }
  end
  
end