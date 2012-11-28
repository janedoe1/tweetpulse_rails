class AddOutreachToTwitterUser < ActiveRecord::Migration
  def change
    add_column :twitter_users, :outreach, :integer
  end
end
