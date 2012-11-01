module ApplicationHelper
  
  def twitter_user_page user
    "http://twitter.com/" + user
  end
  
  def tweet_date date
    date.strftime("%h. %d at %I:%M%p")
  end
end
