class AddCountToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :count, :integer
  end
end
