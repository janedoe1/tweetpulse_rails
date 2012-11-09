class Search < ActiveRecord::Base
  attr_accessible :user_id, :terms_attributes
  belongs_to :user
  has_and_belongs_to_many :terms
  has_many :tweets
  
  accepts_nested_attributes_for :terms, :reject_if => lambda { |a| a[:text].blank? }
    
  # def autosave_associated_records_for_terms
  #   i = 0
  #   terms.each do |term|
  #     t = term.type.constantize.find_or_create_by_text(term.text)
  #     self.terms.push(t)
  #     Rails.logger.info("iteration number #{i}")
  #     i += 1
  #   end
  # end
  
  def get_tweets
    # search twitter using associated terms
<<<<<<< Updated upstream
    self.user.twitter.search(self.search_query, :count => 20).results.map do |status|
      t = TwitterUser.create(:user_id        => status.user.id,
                             :handle         => status.from_user,
                             :follower_count => status.user.followers_count,
                             :friend_count   => status.user.friends_count,
                             :location       => status.user.location)
=======
    twitter_users = []
    tweets = []
    sentiments = []

    Rails.logger.info "Getting tweets for #{self.search_query}..."
    self.user.twitter.search(self.search_query, :count => 30).results.map do |status|
>>>>>>> Stashed changes
      reply_count = status.reply_count.nil? ? 0 : status.reply_count
      # gather users
      twitter_users.push "(#{status.user.id},'#{ActiveRecord::Base.connection.quote_string(status.user.id.to_s)}','#{ActiveRecord::Base.connection.quote_string(status.from_user)}', #{status.user.followers_count}, #{status.user.friends_count},'#{ActiveRecord::Base.connection.quote_string(status.user.location)}', '#{Time.now}', '#{Time.now}')"
      # gather tweets
      tweets.push "(#{status.id},'#{ActiveRecord::Base.connection.quote_string(status.id.to_s)}','#{ActiveRecord::Base.connection.quote_string(status.text)}',#{status.user.id},#{reply_count},'#{status.created_at}', #{self.id},'#{Time.now}', '#{Time.now}')"
      # gather sentiments
      sentiments.push "(#{status.id},'#{ActiveRecord::Base.connection.quote_string(sentiment_label(status.text))}',#{sentiment_probability(status.text, "neg")},#{sentiment_probability(status.text, "pos")},#{sentiment_probability(status.text, "neutral")}, '#{Time.now}', '#{Time.now}')"
      
      Rails.logger.info "Inserting #{twitter_users.length} twitter users into the database..."
      twitter_users.each_slice(1000) do |batch|
        Rails.logger.info "Inserting #{batch.length} twitter users"
        sql = "INSERT INTO twitter_users (id, user_id, handle, follower_count, friend_count, location, created_at, updated_at) VALUES #{batch.join(", ")}
               ON DUPLICATE KEY UPDATE follower_count = VALUES(follower_count), friend_count = VALUES(friend_count), location = VALUES(location), updated_at = VALUES(updated_at)"
        ActiveRecord::Base.connection.execute(sql)
      end
      Rails.logger.info "Inserted #{twitter_users.length} twitter users"
      
      Rails.logger.info "Inserting #{tweets.length} tweets into the database..."
      tweets.each_slice(1000) do |batch|
        Rails.logger.info "Inserting #{batch.length} tweets"
        sql = "INSERT INTO tweets (id, tweet_id, text, twitter_user_id, reply_count, tweeted_at, search_id, created_at, updated_at) VALUES #{batch.join(", ")}
               ON DUPLICATE KEY UPDATE reply_count = VALUES(reply_count), search_id = VALUES(search_id), updated_at = VALUES(updated_at)"                
        ActiveRecord::Base.connection.execute(sql)
      end
      Rails.logger.info "Inserted #{tweets.length} tweets"
      
      Rails.logger.info "Inserting #{sentiments.length} sentiments into the database..."
      sentiments.each_slice(1000) do |batch|
        Rails.logger.info "Inserting #{batch.length} sentiments"
        sql = "INSERT INTO sentiments (tweet_id, label, negative, positive, neutral, created_at, updated_at) VALUES #{batch.join(", ")}"
        ActiveRecord::Base.connection.execute(sql)
      end
      Rails.logger.info "Inserted #{sentiments.length} sentiments"
      
      # t = TwitterUser.create(:user_id        => status.user.id,
      #                              :handle         => status.from_user,
      #                              :follower_count => status.user.followers_count,
      #                              :friend_count   => status.user.friends_count,
      #                              :location       => status.user.location)
      #       reply_count = status.reply_count.nil? ? 0 : status.reply_count
      #       tweet = self.tweets.create(:tweet_id => status.id,
      #                                  :text => status.text,
      #                                  :twitter_user_id => t.id,
      #                                  :reply_count => reply_count,
      #                                  :tweeted_at => status.created_at)
      #       Sentiment.create(:tweet_id => tweet.id, 
      #                        :label => sentiment_label(status.text),
      #                        :negative => sentiment_probability(status.text, "neg"),
      #                        :positive => sentiment_probability(status.text, "pos"),
      #                        :neutral => sentiment_probability(status.text, "neutral") )
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
  end
  
  def get_sentiment(text)
    HTTParty.post(sentiment_api_url, :body => "text=#{text}", :headers => {'Content-Type' => 'application/json'}).parsed_response
  end
  
  def sentiment_label(text)
    get_sentiment(text)["label"]
  end
  
  def sentiment_probability(text, category)
    get_sentiment(text)["probability"][category]
  end
  
  def gexf
    b = "51"
    g = "51"
    r="255"
    @tweets = self.tweets
    xml = ::Builder::XmlMarkup.new(:indent => 2)
    xml.instruct! :xml
    xml.gexf 'xmlns' => "http://www.gephi.org/gexf", 'xmlns:viz' => "http://www.gephi.org/gexf/viz"  do
      xml.graph 'defaultedgetype' => "directed", 'idtype' => "string", 'type' => "static" do
        xml.nodes :count => @tweets.size + 1 do
          xml.node :id => 0, :label => self.label
          @tweets.each_with_index do |tweet, index|
            xml.node :id => index+1, :label => tweet.twitter_user.handle do
              xml.tag!("viz:size", :value => normalize(tweet.twitter_user.follower_count, TwitterUser.all.map {|u| u.follower_count}.min,TwitterUser.all.map {|u| u.follower_count}.max,10, 50))
              xml.tag!("viz:color", :b => b, :g => g, :r => r)
              xml.tag!("viz:position", :x => "20", :y => "30", :z => "0") 
    	      end
          end
        end
        xml.edges :count => @tweets.size do
          @tweets.each_with_index do |tweet, index|
            xml.edge:id => index, :source => 0, :target => index+1
          end
        end
      end
    end
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
