class AddUserIdToTerm < ActiveRecord::Migration
  def change
    add_column :terms, :user_id, :integer
  end
end
