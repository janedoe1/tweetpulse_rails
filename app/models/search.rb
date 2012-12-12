class Search < ActiveRecord::Base
  attr_accessible :user_id, :terms_attributes, :search_id, :from_date, :to_date, :count
  belongs_to :user
  has_and_belongs_to_many :terms
  has_many :tweets
  has_many :twitter_users, :dependent => :delete_all
  
  accepts_nested_attributes_for :terms, :twitter_users, :reject_if => lambda { |a| a[:text].blank? }
  validates_presence_of :from_date, :to_date, :count
  validates :count, :numericality => { :greater_than => 0 }

  def get_twitter_users current_user
    source = "twitter"
    term = self.search_query
    #first = self.from_date
    last = "today" #self.to_date
    count = "30"
    number = "50"
    Rails.logger.info "Calling PeopleBrowsr API..."
    response = current_user.peoplebrowsr.kred_retweet_influence(source: source, 
                               term: term,
                               last: last,
                               count: count,
                               number: number)
    result = response['data']
    Rails.logger.info "PeopleBrowsr API Results"
    Rails.logger.info response
    result.each do |influencer|
      self.twitter_users.create(
                :user_id        => influencer['numeric_id'].to_s,
                :handle         => influencer['id'],
                :avatar         => influencer['avatar'],
                :influence      => influencer['influence'],
                :outreach       => influencer['outreach'],
                :follower_count => influencer['followers'],
                :friend_count   => influencer['following'])
    end
    self.twitter_users
  end
  
  def get_tweets
    # search twitter using associated terms
    self.user.twitter.search(self.search_query, :count => 20).results.map do |status|
      t = TwitterUser.create(:user_id        => status.user.id,
                             :handle         => status.from_user,
                             :follower_count => status.user.followers_count,
                             :friend_count   => status.user.friends_count,
                             :location       => status.user.location)
      reply_count = status.reply_count.nil? ? 0 : status.reply_count
      tweet = self.tweets.create(:status_id => status.id,
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
    search += keywords.join(" ") unless keywords.blank?
    search += " ##{hashtags.join(" ")}" unless hashtags.blank?
    Rails.logger.info "Search query: #{search}"
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
    data[:nodes].push({:name => self.label, :size => 20, :color => 'white'}) 
    self.twitter_users.map {|twitteruser| data[:nodes].push({:name => "@" + twitteruser.handle, :size => normalize(twitteruser.follower_count), :color => '#F7B100',:avatar =>twitteruser.avatar,:twitter_user_tooltip => Rails.application.routes.url_helpers.twitter_user_tooltip_path(twitteruser)})}
    self.twitter_users.map.with_index {|tweet, index| data[:links].push({:source => 0, :target => index+1, :value => index, :size => 1})}
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
  
  def to_csv
    col_header = ["user_id", "handle", "follower_count", "friend_count", "influence", "outreach"]
    CSV.generate do |csv|
      csv << col_header
      self.twitter_users.each do |twitter_user|
        csv << twitter_user.attributes.values_at(*col_header)
      end
    end
  end
  
  def sentiment_color tweet
    case tweet.sentiment.label
    when 'pos'
      '#86B704'
    when 'neg'
      '#F13943'
    else
      '#0162D3'
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
    self.twitter_users.collect {|t| t.follower_count}.min
  end
  
  def max_node_size
    self.twitter_users.collect {|t| t.follower_count}.max
  end
end
