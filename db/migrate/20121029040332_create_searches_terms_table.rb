class CreateSearchesTermsTable < ActiveRecord::Migration
  def change
    create_table :searches_terms, :id => false do |t|
      t.integer :search_id
      t.integer :term_id
    end
  end
end
