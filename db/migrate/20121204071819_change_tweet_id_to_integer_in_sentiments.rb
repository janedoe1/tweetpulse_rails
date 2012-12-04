class ChangeTweetIdToIntegerInSentiments < ActiveRecord::Migration
  def change
    rename_column :sentiments, :tweet_id, :tweet_id_string
    add_column :sentiments, :tweet_id, :integer

    Sentiment.reset_column_information
    Sentiment.find_each { |s| s.update_attribute(:tweet_id, s.tweet_id_string.to_i) } 
    remove_column :sentiments, :tweet_id_string
  end

end
