class TwitterUser < ActiveRecord::Base
  attr_accessible :follower_count, :friend_count, :handle, :location, :user_id

  has_many :tweets
  has_many :retweets
  
  def common_followers other_user
    client = Twitter::Client.new
    begin
      my_followers = client.follower_ids(self.user_id.to_i).ids
      other_followers = client.follower_ids(other_user.user_id.to_i).ids
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
