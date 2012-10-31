class ChangeTweetToSearch < ActiveRecord::Migration
  def change
    add_column :tweets, :search_id, :integer
    remove_column :tweets, :term_id
  end
end
