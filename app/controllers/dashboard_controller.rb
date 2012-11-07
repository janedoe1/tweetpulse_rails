class DashboardController < ApplicationController
  before_filter :check_twitter_auth
  before_filter :prepare_data, :only => :index
  
  def index
    @searches = current_user.searches
  end
  
  protected
  
  def prepare_data
    @presenter = DashboardPresenter.new(current_user)
  end
end
