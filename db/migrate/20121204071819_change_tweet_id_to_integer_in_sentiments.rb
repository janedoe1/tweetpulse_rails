class ChangeTweetIdToIntegerInSentiments < ActiveRecord::Migration
  def change
    change_column :sentiments, :tweet_id, :integer
  end
end
