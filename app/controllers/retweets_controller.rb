class RetweetsController < ApplicationController

  def show_tooltip
    @twitter_user = TwitterUser.find(params[:twitter_user_id])
    render :partial => 'twitter_users/show_tooltip'
    #render :layout => false
  end

	def show_tooltip
    @retweet = Retweet.find(params[:id])
    render :partial => 'retweets/show_tooltip'
    #render :layout => false
  end

end
