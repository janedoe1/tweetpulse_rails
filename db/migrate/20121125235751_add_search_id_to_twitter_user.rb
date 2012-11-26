class AddSearchIdToTwitterUser < ActiveRecord::Migration
  def change
    add_column :twitter_users, :search_id, :integer
  end
end
