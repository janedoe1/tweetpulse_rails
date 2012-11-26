class Search < ActiveRecord::Base
  attr_accessible :user_id, :terms_attributes, :search_id
  belongs_to :user
  has_and_belongs_to_many :terms
  has_many :tweets
  has_many :TwitterUsers
  
  accepts_nested_attributes_for :terms, :TwitterUsers, :reject_if => lambda { |a| a[:text].blank? }
    
  # def autosave_associated_records_for_terms
  #   i = 0
  #   terms.each do |term|
  #     t = term.type.constantize.find_or_create_by_text(term.text)
  #     self.terms.push(t)
  #     Rails.logger.info("iteration number #{i}")
  #     i += 1
  #   end
  # end
  
  #Kred API
  def get_twitter_users
	require 'net/http'
	require 'json'         
    
	app_id = "5e918fed"
	app_key = "0e413b1d6831771be8af2bb2999508db"

	source = "twitter"
	term = self.search_query
	first = "yesterday"
	count = "30"

	url = 'http://api.peoplebrowsr.com/kredinfluence?'
	url = url + 'app_id=' + app_id
	url = url + '&app_key=' + app_key
	url = url + '&term=' + term
	url = url + '&source=' + source
	url = url + "&first=" + first
	url = url + "&count=" + count
	uri = URI.parse(URI.encode(url.strip))
	response = Net::HTTP.get_response(uri)
	result = JSON.parse(response.body)['data']
	result.each do |influencer|
		self.TwitterUsers.create(
							:user_id => influencer['numeric_id'].to_s,
							:handle         => influencer['name'],
							:follower_count => influencer['followers'],
							:friend_count   => influencer['following'])
		end
	self.TwitterUsers
   end
	
  
  def get_tweets
    # search twitter using associated terms
    self.user.twitter.search(self.search_query, :count => 29).results.map do |status|
      t = TwitterUser.create(:user_id        => status.user.id,
                             :handle         => status.from_user,
                             :follower_count => status.user.followers_count,
                             :friend_count   => status.user.friends_count,
                             :location       => status.user.location)
      reply_count = status.reply_count.nil? ? 0 : status.reply_count
      tweet = self.tweets.create(:tweet_id => status.id,
                                 :text => status.text,
                                 :twitter_user_id => t.id,
                                 :reply_count => reply_count,
                                 :tweeted_at => status.created_at)
      Sentiment.create(:tweet_id => tweet.id, 
                       :label => sentiment_label(status.text),
                       :negative => sentiment_probability(status.text, "neg"),
                       :positive => sentiment_probability(status.text, "pos"),
                       :neutral => sentiment_probability(status.text, "neutral") )
      #if status.retweet_count > 0
        # get the retweets
      # => end
    end
    self.tweets
  end
  
  def label
    self.terms.collect {|t| t.to_s}.join(" ")
  end
  
  def search_query
    keywords = []
    hashtags = []
    self.terms.each do |term|
      if term.type == "KeywordTerm"
        keywords.push(term.text)
      elsif term.type == "HashtagTerm"
        hashtags.push(term.text)
      end
    end
    handle = self.terms.user_terms.first.text rescue ''
    search = ""
    search += "from:#{handle} " unless handle.blank?
    search += keywords.join(" ") if keywords
    search += " ##{hashtags.join(" ")}" if hashtags
    search
  end
  
  def sentiment_api_url
    'http://text-processing.com/api/sentiment/'
    #"http://www.sentiment140.com/api/classify?text="
  end
  
  def get_sentiment(text)
    HTTParty.post(sentiment_api_url, :body => "text=#{text}", :headers => {'Content-Type' => 'application/json'}).parsed_response
    #HTTParty.get(sentiment_api_url+text, :headers => {'Content-Type' => 'application/json'}).parsed_response
  end
  
  def sentiment_label(text)
    get_sentiment(text)["label"]
    # case get_sentiment(text)["results"]["polarity"]
    # when 0
    #   'neg'
    # when 4
    #   'pos'
    # else
    #   'neutral'
    # end
  end
  
  def sentiment_probability(text, category)
    get_sentiment(text)["probability"][category]
  end
  
  def user_to_json
	data = {:nodes => [], :links => []}
    # set root node
    data[:nodes].push({:name => self.label, :size => normalize(max_node_size), :color => 'white'}) 
    self.TwitterUsers.map {|twitteruser| data[:nodes].push({:name => "@" + twitteruser.handle, :size => normalize(twitteruser.follower_count), :color => 'red',:tweet_tooltip => Rails.application.routes.url_helpers.tweet_tooltip_path(twitteruser)})}
    self.TwitterUsers.map.with_index {|tweet, index| data[:links].push({:source => 0, :target => index+1, :value => index, :size => 1})}
    Rails.logger.info data
    data.to_json
  end
  
  def to_json
    data = {:nodes => [], :links => []}
    # set root node
    data[:nodes].push({:name => self.label, :size => normalize(max_node_size), :color => 'white'}) 
    self.tweets.map {|tweet| data[:nodes].push({:name => "@" + tweet.twitter_user.handle, :size => normalize(tweet.twitter_user.follower_count), :color => sentiment_color(tweet), :tweet_tooltip => Rails.application.routes.url_helpers.tweet_tooltip_path(tweet)})}
    self.tweets.map.with_index {|tweet, index| data[:links].push({:source => 0, :target => index+1, :value => index, :size => 1})}
    Rails.logger.info data
    data.to_json
  end
  
  def sentiment_color tweet
    case tweet.sentiment.label
    when 'pos'
      'green'
    when 'neg'
      'red'
    else
      'gray'
    end
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
    self.tweets.first.twitter_user.follower_count
  end
  
  def min_node_size
    self.tweets.map {|t| t.twitter_user.follower_count}.min
  end
  
  def max_node_size
    self.tweets.map {|t| t.twitter_user.follower_count}.max
  end
end
