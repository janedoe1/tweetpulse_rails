class AddInfluenceToTwitterUser < ActiveRecord::Migration
  def change
    add_column :twitter_users, :influence, :integer
  end
end
