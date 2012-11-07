class DashboardPresenter

  attr_reader :tag, :graph_min, :graph_max

  def initialize(current_user, options = {})
    @user = current_user
    @searches = current_user.searches
    @tweets = @searches.collect {|s| s.tweets}.flatten
    @sentiments = Sentiment.where("tweet_id in (?)", @tweets.map(&:id))
  end
  
  def sentiment_tweet_count(label)
    @sentiments.where(:label => label).count
  end
  
  def search_tweet_counts(count=5)
    @searches.order("created_at DESC").limit(count).collect {|search| %(["#{search.label}", #{(search.tweets.count)}])}
  end
  
  
  
end