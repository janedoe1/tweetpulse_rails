class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  
  def check_twitter_auth
    unless !!current_user.authentications.find_by_provider('twitter')
      flash[:error] = "You must authenticate with Twitter before tracking terms"
      redirect_to edit_user_registration_path
    end
  end
end
