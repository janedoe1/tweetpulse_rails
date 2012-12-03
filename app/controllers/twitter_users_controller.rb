class TwitterUsersController < ApplicationController
	
  # GET /twitter_users
  # GET /twitter_users.json
  def index
    @twitter_users = current_user.TwitterUsers

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @twitter_users}
    end
  end
  
  # GET /twitter_users/1
  # GET /twitter_users/1.json
  def show
    @twitter_user = TwitterUser.find(params[:id])
    @tweets = @twitter_user.tweets.blank? ? @twitter_user.get_tweets(current_user) : @twitter_user.tweets
    if @twitter_user.tweets.blank?
      flash[:error] = "No tweets matched this search."
      #redirect_to searches_path
    end
	respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @twitter_user.to_json }
    end	
  end
  
  def refresh_results
    @twitter_user = TwitterUsers.find(params[:id])
    @twitter_user.tweets.destroy_all
    begin
      @twitter_user.get_tweets(current_user)
    rescue Twitter::Error::InternalServerError => e
      puts e
      Rails.logger.info e.message
      flash[:error] = 'Twitter is not responding. Please try again in a few minutes.'
    end
    redirect_to twitter_user_path(@twitter_user)
  end
  
  def show_tooltip
    @twitter_user = TwitterUser.find(params[:twitter_user_id])
    render :partial => 'twitter_users/show_tooltip'
    #render :layout => false
  end
  
  protected

end
