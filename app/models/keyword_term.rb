class KeywordTerm < Term
  
  def get_tweets
    self.user.twitter.search(self.text, :count => 5).results.map do |status|
      self.tweets.create(:tweet_id => status.id, :from_user => status.from_user, :text => status.text)
    end
    self.tweets
  end
  
end
