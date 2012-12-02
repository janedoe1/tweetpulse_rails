class AddFromDateAndToDateToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :from_date, :datetime
    add_column :searches, :to_date, :datetime
  end
end
