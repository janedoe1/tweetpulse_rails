class CreateRetweets < ActiveRecord::Migration
  def change
    create_table :retweets do |t|
      t.string :tweet_id
      t.string :twitter_user_id

      t.timestamps
    end
  end
end
