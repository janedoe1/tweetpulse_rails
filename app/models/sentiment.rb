class Sentiment < ActiveRecord::Base
  attr_accessible :label, :negative, :neutral, :positive, :tweet_id
  belongs_to :tweet
end
