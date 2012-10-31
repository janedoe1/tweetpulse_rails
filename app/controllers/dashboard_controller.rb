class DashboardController < ApplicationController
  before_filter :check_twitter_auth
  def index
    @searches = current_user.searches
  end
end
