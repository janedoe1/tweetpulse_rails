class DashboardController < ApplicationController
  before_filter :check_twitter_auth
  before_filter :check_peoplebrowsr_auth
  before_filter :prepare_data, :only => :index
  
  def index
    @searches = current_user.searches
    render :layout => false if request.xhr?
  end
  
  def refresh_graphs
    @search = params[:search_id]
    prepare_data(@search)
    render :partial => "dashboard/graphs"
  end
  
  protected
  
  def prepare_data(search_id=nil)
    @presenter = search_id.nil? ? DashboardPresenter.new(current_user) : DashboardPresenter.new(current_user, :search => search_id)
  end
end
