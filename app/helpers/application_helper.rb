module ApplicationHelper
  
  def twitter_user_page user
    "http://twitter.com/" + user
  end
  
  def tweet_date date
    date.strftime("%h. %d at %I:%M%p")
  end
  
  def link_to_tweet tweet
    "https://twitter.com/#{tweet.twitter_user.handle}/status/#{tweet.status_id}"
  end
  def databox(title, options={})
    content_tag(:div, :class => "box #{options[:class]}", :id => options[:id], :style => options[:style]) do
      content_tag(:div, content_tag(:h2, raw(title)), :class => "box-header") <<
      content_tag(:div, :class => "box-content", :style => "#{options[:inner_style]}") do
        yield
      end
    end
  end
  
  def row
    content_tag(:div, :class => "row-fluid") do
      yield
    end
  end
  
end
