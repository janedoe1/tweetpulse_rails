class TwitterUsersController < ApplicationController
  layout proc {|controller| controller.request.xhr? ? false: "application" }
  
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
    #@tweets = @twitter_user.tweets.blank? ? @twitter_user.get_tweets(current_user) : @twitter_user.tweets
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @twitter_user.to_json }
      format.csv { send_data @twitter_user.to_csv, :filename => "@#{@twitter_user.handle} tweet export - TweetPulse " }
    end 
  end
  
  def refresh_results
    @twitter_user = TwitterUser.find(params[:twitter_user_id])
    @twitter_user.tweets.delete_all if @twitter_user.tweets
    begin
      @twitter_user.get_tweets(current_user)
    rescue Twitter::Error::InternalServerError => e
      Rails.logger.info e.message
      flash[:error] = 'Twitter is not responding. Please try again in a few minutes.'
    end
    render :show
  end
  
  def show_tooltip
    @twitter_user = TwitterUser.find(params[:twitter_user_id])
    render :partial => 'twitter_users/show_tooltip'
    #render :layout => false
  end
  
  protected

end
