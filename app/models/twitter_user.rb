class TwitterUser < ActiveRecord::Base
  attr_accessible :follower_count, :friend_count, :handle, :location, :user_id, :avatar, :influence, :outreach

  belongs_to :search, :dependent => :destroy
  has_many :tweets
  has_many :retweets
  
  def get_tweets current_user
      current_user.twitter.search(self.search_query, :count => 29).results.map do |status|
      reply_count = status.reply_count.nil? ? 0 : status.reply_count
      tweet = self.tweets.create(:status_id => status.id,
                                 :text => status.text,
                                 :twitter_user_id => self.user_id,
                                 :reply_count => reply_count,
                                 :tweeted_at => status.created_at,
                                 :search_id => self.search_id)
      Sentiment.create(:tweet_id => tweet.id, 
                       :label => tweet.sentiment_label)
    end
    self.tweets
  end
  
  def label
    self.terms.collect {|t| t.to_s}.join(" ")
  end
  
  def sentiment_api_url
    #'http://text-processing.com/api/sentiment/'
    email = URI.encode("kconarro@andrew.cmu.edu")
    "http://www.sentiment140.com/api/classify?app_id=#{email}&"
  end
  
  def get_sentiment(text)
    #HTTParty.post(sentiment_api_url, :body => "text=#{text}", :headers => {'Content-Type' => 'application/json'}).parsed_response
    tweet_text = URI.encode(text.gsub(' ', '+'))
    query_text = URI.encode(self.search.label.gsub(' ', '+'))
    url = sentiment_api_url+"text=#{tweet_text}&query=#{query_text}"
    #raise url.inspect
    response = HTTParty.get(url, :headers => {'Content-Type' => 'application/json'}).parsed_response
    Rails.logger.info "Sentiment API Results"
    Rails.logger.info response
    response
  end
  
  def tweet_range
    tweets = self.tweets.order("tweeted_at DESC")
    from = tweets.first.tweeted_at.strftime("%h. %d at %I:%M%p")
    to = tweets.last.tweeted_at.strftime("%h. %d at %I:%M%p")
    "#{from} - #{to}"
  end
  
  def sentiment_label
    #get_sentiment(text)["label"]
    case get_sentiment(text)["results"]["polarity"]
    when 0
      'neg'
    when 4
      'pos'
    else
      'neutral'
    end
  end
  
  
  # search_query method is wrong!
  def search_query
    require 'uri'
      keywords = []
      hashtags = []
      self.search.terms.each do |term|
        if term.type == "KeywordTerm"
          keywords.push(term.text)
        elsif term.type == "HashtagTerm"
          hashtags.push(term.text)
        end
      end
      handle = self.handle
      search = ""
      search += "from:#{handle}+" unless handle.blank?
      search += keywords.join("+") if keywords
      search += " ##{hashtags.join("+")}" if hashtags
    search=URI.encode(search)
    search = search + ' -rt'
    Rails.logger.info "Search query: #{search}"
    search
  end
  
  def sentiment_probability(text, category)
    0
    #get_sentiment(text)["probability"][category]
  end
  
  def label
    self.search.terms.collect {|t| t.to_s}.join(" ")
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

  def common_followers (current_user,other_user)
    #client = Twitter::Client.new
    begin
      my_followers = current_user.twitter.follower_ids(self.user_id.to_i).ids
      other_followers = current_user.twitter.follower_ids(other_user.user_id.to_i).ids
      2*(my_followers & other_followers).count.to_f / (my_followers.count + other_followers.count).to_f
    rescue Twitter::Error::TooManyRequests => e
      puts e
      Rails.logger.info 'Twitter rate limit exceeded'
      return e
    end
    
    # cursor = -1
    #    followerIds = []
    #    until cursor == 0 do
    #      begin
    #        followers = client.follower_ids(self.user_id.to_i,{:cursor=>cursor})
         # rescue Twitter::Error::TooManyRequests => e
         #   puts e
         #   Rails.logger.info 'Twitter rate limit exceeded'
         #   return e
         # end
    #      cursor = followers.next_cursor
    #      followerIds += followers.ids
    #      sleep(2)
    #    end
    #    followerIds.count
  end
  
  
end
