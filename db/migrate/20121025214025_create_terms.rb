class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :type
      t.string :text

      t.timestamps
    end
  end
end
