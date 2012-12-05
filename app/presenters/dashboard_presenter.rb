class DashboardPresenter

  attr_reader :tag, :graph_min, :graph_max, :searches, :sentiments, :tweets, :twitter_users

  def initialize(current_user, options = {})
    @user = current_user
    @searches = current_user.searches
    @search = @user.searches.find(options[:search]) unless options[:search].nil?
    @tweets = @search.nil? ? @searches.collect {|s| s.tweets}.flatten : @search.tweets
    @sentiments = Sentiment.where("tweet_id in (?)", @tweets.map(&:id))
    @twitter_users = @search.nil? ? @searches.collect {|s| s.twitter_users}.flatten : @search.twitter_users
  end
  
  def sentiment_tweet_count(label)
    @sentiments.where(:label => label).count
  end
  
  def search_tweet_counts(count=5)
    #@searches.order("created_at DESC").limit(count).collect {|search| %(["#{search.label}", #{(search.tweets.count)}])}
  end
  
  def top_users(count=5)
    TwitterUser.find(@twitter_users.map(&:id), :order => "follower_count DESC").take(count)
  end
  
  def top_influencers(count=5)
    self.influencers(count).collect {|twitter_user| %(["@#{twitter_user.handle}", #{(twitter_user.influence)}])}
  end
  
  def influence_vs_outreach(count=20)
    self.influencers(count).collect {|twitter_user| %([#{twitter_user.influence}, #{(twitter_user.outreach)},"@#{twitter_user.handle} Influence: #{twitter_user.influence} Outreach: #{twitter_user.outreach}"])}
  end
  
  def top_tweets(count=4)
    Tweet.find(@tweets.map(&:id)).sort_by {|t| t.retweets.count}.take(count)
  end
  
  protected
  
  def influencers(count=5)
    TwitterUser.find(@twitter_users.map(&:id), :order => "influence DESC").take(count)
  end
end