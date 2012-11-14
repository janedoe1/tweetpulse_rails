class AddTweetedAtToRetweets < ActiveRecord::Migration
  def change
    add_column :retweets, :tweeted_at, :datetime
  end
end
