class AddAvatarToTwitterUser < ActiveRecord::Migration
  def change
    add_column :twitter_users, :avatar, :string
  end
end
