class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :token, :secret, :username, :profile_image_url
  
end
