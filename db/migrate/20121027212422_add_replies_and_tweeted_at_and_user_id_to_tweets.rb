class AddRepliesAndTweetedAtAndUserIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :reply_count, :integer
    add_column :tweets, :tweeted_at, :datetime
    add_column :tweets, :user_id, :string
  end
end
