class AddTextAndFromUserToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :text, :string
    add_column :tweets, :from_user, :string
  end
end
