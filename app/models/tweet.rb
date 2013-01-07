class Tweet < ActiveRecord::Base
  attr_accessible :status_id, :text, :twitter_user_id, :reply_count, :tweeted_at, :search_id
  
  validates_uniqueness_of :status_id
  
  belongs_to :search
  belongs_to :twitter_user
  has_one :sentiment, :dependent => :destroy
  has_many :retweets, :dependent => :destroy
  
  scope :positive, includes(:sentiment).where("sentiment.label=?", "pos")
  scope :negative, where(:is_enabled => true, :is_archived => false)
  scope :neutral, where(:is_enabled => true, :is_archived => false)
  
  def get_data current_user
    tweet = current_user.twitter.status(self.status_id, :include_entities => true)
    {:retweeters_count => tweet.retweeters_count,
     :repliers_count   => tweet.repliers_count,
     :followers_count  => tweet.user.followers_count,
     :friends_count    => tweet.user.friends_count,
     :retweets         => current_user.twitter.retweets(self.status_id)}
  end
  
  def get_retweets current_user
    # search retweets using associated terms
    # client = Twitter::Client.new
    current_user.twitter.retweets(self.status_id, :count => 29).map do |status|
      api = current_user.peoplebrowsr
      
      source = "twitter"
      term = status.user.screen_name.downcase 
      response = api.kred_score(source: source, term: term)
      result = response['data']
      
      outreach = result[0]['outreach'].nil? ? 0 : result[0]['outreach'].to_i
      influence = result[0]['influence'].nil? ? 0 : result[0]['influence'].to_i
      
      t = TwitterUser.create(:user_id        => status.user.id,
                             :handle         => status.user.screen_name,
                             :follower_count => status.user.followers_count,
                             :friend_count   => status.user.friends_count,
                             :avatar         => status.user.profile_image_url,
                             :outreach       => outreach,
                             :influence      => influence,
                             :location       => status.user.location)
      retweet = self.retweets.create(:tweet_id => status.user.id,
                   :twitter_user_id => t.id,
                   :tweeted_at => status.created_at)
    end
    self.retweets
  end
  
  def to_json current_user
    data = {:nodes => [], :links => []}
    # set root node
    data[:nodes].push({:name => "@#{self.twitter_user.handle}", :size => 20, :color => self.sentiment_color})
    self.retweets.map {|retweet| data[:nodes].push({:name => "@" + retweet.twitter_user.handle, :size =>normalize(retweet.twitter_user.follower_count) , :color => self.sentiment_color, :tweet_tooltip => Rails.application.routes.url_helpers.retweet_tooltip_path(retweet)})}
    self.retweets.map.with_index {|retweet, index| data[:links].push({:source => 0, :target => index+1, :value => index, :size => self.thickness(retweet.twitter_user), :length=> 400-length_normalize(Time.now.to_i-retweet.tweeted_at.to_i)})}
    Rails.logger.info data
    data.to_json
  end
  
  def to_csv
    col_header = ["original_status_id", "retweeted by", "retweeted_at"]
    rows = []
    CSV.generate do |csv|
      csv << col_header
      self.retweets.each do |retweet|
        csv << [self.status_id, retweet.twitter_user.handle, retweet.tweeted_at]
      end
    end
  end
  
  def sentiment_api_url
    #'http://text-processing.com/api/sentiment/'
    email = URI.encode("kconarro@andrew.cmu.edu")
    "http://www.sentiment140.com/api/classify?app_id=#{email}&"
  end
  
  def get_sentiment(text)
    #HTTParty.post(sentiment_api_url, :body => "text=#{text}", :headers => {'Content-Type' => 'application/json'}).parsed_response
    tweet_text = URI.encode(text.gsub(' ', '+'))
    query_text = URI.encode(search.label.gsub(' ', '+'))
    url = sentiment_api_url+"text=#{tweet_text}&query=#{query_text}"
    response = HTTParty.get(url, :headers => {'Content-Type' => 'application/json'}).parsed_response
    Rails.logger.info "Sentiment API Results"
    Rails.logger.info response
    response
  end
  
  def sentiment_label
    #get_sentiment(text)["label"]
    case get_sentiment(self.text)["results"]["polarity"]
    when 0
      'neg'
    when 4
      'pos'
    else
      'neutral'
    end
  end
  
  def sentiment_color
    case self.sentiment.label
    when 'pos'
      '#86B704'
    when 'neg'
      '#F13943'
    else
      '#0162D3'
    end
  end
  
  def retweet_range
    retweets = self.retweets.order("tweeted_at ASC")
    from = retweets.first.tweeted_at.strftime("%h. %d at %I:%M%p")
    to = retweets.last.tweeted_at.strftime("%h. %d at %I:%M%p")
    "#{from} - #{to}"
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
  
  def thickness (leaf_user)
    center_inf = self.twitter_user.influence.to_f
    center_outr = self.twitter_user.outreach.to_f
    leaf_inf = leaf_user.influence.to_f
    leaf_outr = leaf_user.outreach.to_f

    factor = (leaf_inf/center_inf)*(leaf_outr/center_outr)

    t = 10*factor
    return t
  end
  
  def user_node_size
    self.retweets.first.twitter_user.follower_count
  end
  
  def min_node_size
    self.retweets.map {|t| t.twitter_user.follower_count}.min
  end
  
  def max_node_size
    self.retweets.map {|t| t.twitter_user.follower_count}.max
  end
  
  def length_normalize val
    unless min_node_size == max_node_size
      xmin = min_length_size
      xmax = max_length_size
      norm_min = 100
      norm_max = 200
      xrange = xmax-xmin
      norm_range = norm_max-norm_min
      (val-xmin).to_f * (norm_max.to_f - norm_min.to_f) / (xmax.to_f - xmin.to_f) + norm_min
    else
      100
    end
    #y = 1 + (x-A)*(10-1)/(B-A)
    #norm_min + (val-xmin) * (norm_range.to_f / xrange)
  end
  
  def user_length_size
    Time.now-self.retweets.first.tweeted_at
  end
  
  def min_length_size
    self.retweets.map {|t| (Time.now-t.tweeted_at)}.min
  end
  
  def max_length_size
    self.retweets.map {|t| (Time.now-t.tweeted_at)}.max
  end
  
end
