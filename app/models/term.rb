class Term < ActiveRecord::Base
  attr_accessible :text, :type
  validates_presence_of :text, :type
  #validates_uniqueness_of :text
  
  has_and_belongs_to_many :searches

  scope :keyword_terms, where(:type => 'KeywordTerm')
  scope :hashtag_terms, where(:type => 'HashtagTerm')
  scope :user_terms, where(:type => 'UserTerm')
  
  def types
    ['KeywordTerm', 'HashtagTerm', 'UserTerm']
  end
  
  def get_tweets
  end
  
  def to_s
    self.text
  end
end
