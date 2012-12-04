class ChangeTweetIdToIntegerInRetweets < ActiveRecord::Migration
  def change
    rename_column :retweets, :tweet_id, :tweet_id_string
    add_column :retweets, :tweet_id, :integer

    Retweet.reset_column_information
    Retweet.find_each { |r| r.update_attribute(:tweet_id, r.tweet_id_string.to_i) } 
    remove_column :retweets, :tweet_id_string
  end
end
