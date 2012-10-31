class CreateSentiments < ActiveRecord::Migration
  def change
    create_table :sentiments do |t|
      t.string :tweet_id
      t.string :label
      t.float :negative
      t.float :positive
      t.float :neutral

      t.timestamps
    end
  end
end
