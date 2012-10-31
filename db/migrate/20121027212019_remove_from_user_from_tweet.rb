class RemoveFromUserFromTweet < ActiveRecord::Migration
  def up
    remove_column :tweets, :from_user
  end

  def down
    add_column :tweets, :from_user
  end
end
