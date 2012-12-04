class ChangeColumnNameInTweet < ActiveRecord::Migration
  def change
    change_table :tweets do |t|
      t.rename :tweet_id, :status_id
    end
  end
end
