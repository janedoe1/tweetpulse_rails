class AddTermIdToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :term_id, :integer
  end
end
