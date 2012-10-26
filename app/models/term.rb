class Term < ActiveRecord::Base
  attr_accessible :text, :type
  validates_presence_of :text, :type
  
  belongs_to :user
  has_many :tweets
    
  scope :keyword_terms, where(:type => 'KeywordTerm')
  scope :hashtag_terms, where(:type => 'HashtagTerm')
  scope :user_terms, where(:type => 'UserTerm')
  
  def types
    ['KeywordTerm', 'HashtagTerm', 'UserTerm']
  end
  
  
  
  def get_tweets
  end
end
