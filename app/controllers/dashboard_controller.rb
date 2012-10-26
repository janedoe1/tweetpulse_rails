class DashboardController < ApplicationController
  before_filter :check_twitter_auth
  def index
  end
end
