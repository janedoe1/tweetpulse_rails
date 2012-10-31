class AddTwitterUserIdToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :twitter_user_id, :integer
    remove_column :tweets, :user_id
  end
end
