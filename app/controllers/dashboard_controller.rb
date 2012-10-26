class DashboardController < ApplicationController
  before_filter :check_twitter_auth
  def index
    @terms = current_user.terms
  end
end
