class User < ActiveRecord::Base
  
  has_many :authentications
  has_many :searches
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  # attr_accessible :title, :body
  validates_presence_of :first_name, :last_name
  
  def twitter
    unless @twitter_user
      authentication = self.authentications.find_by_provider('twitter')
      @twitter_user = Twitter::Client.new(:oauth_token => authentication.token, :oauth_token_secret => authentication.secret) rescue nil
    end
    @twitter_user
  end
  
  def peoplebrowsr
    authentication = self.authentications.find_by_provider('peoplebrowsr')
    Kred::KredAPI.new(authentication.token, authentication.secret)
  end
  
  def twitter_auth
    self.authentications.find_by_provider('twitter')
  end
  
  def peoplebrowsr_auth
    self.authentications.find_by_provider('peoplebrowsr')
  end
  
  def name
    self.first_name + ' ' + self.last_name
  end
end
