class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :user_id
      t.string :handle
      t.integer :follower_count
      t.integer :friend_count
      t.string :location

      t.timestamps
    end
  end
end
