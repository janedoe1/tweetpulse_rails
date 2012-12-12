class TweetsController < ApplicationController
  layout 'application', :except => [:show_tooltip]
  layout proc {|controller| controller.request.xhr? ? false: "application" }
  
  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tweets }
    end
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    @tweet = Tweet.find(params[:id])
    #@retweets = @tweet.retweets.blank? ? @tweet.get_retweets(current_user) : @tweet.retweets

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tweet.to_json(current_user) }
      format.csv { send_data @tweet.to_csv, :filename => "@#{@tweet.twitter_user.handle} retweet export - TweetPulse" }
    end
  end

  # GET /tweets/new
  # GET /tweets/new.json
  def new
    @tweet = Tweet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tweet }
    end
  end

  # GET /tweets/1/edit
  def edit
    @tweet = Tweet.find(params[:id])
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(params[:tweet])

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render json: @tweet, status: :created, location: @tweet }
      else
        format.html { render action: "new" }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tweets/1
  # PUT /tweets/1.json
  def update
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      if @tweet.update_attributes(params[:tweet])
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy

    respond_to do |format|
      format.html { redirect_to tweets_url }
      format.json { head :no_content }
    end
  end
  
  def show_tooltip
    @tweet = Tweet.find(params[:tweet_id])
    render :partial => 'tweets/show_tooltip'
    #render :layout => false
  end
  
  def refresh_results
    @tweet = Tweet.find(params[:tweet_id])
    @tweet.retweets.destroy_all
    begin
      @tweet.get_retweets(current_user)
    rescue Twitter::Error::InternalServerError => e
      puts e
      Rails.logger.info e.message
      flash[:error] = 'Twitter is not responding. Please try again in a few minutes.'
    rescue Twitter::Error::NotFound => e
      puts e
      Rails.logger.info e.message
      flash[:error] = 'Twitter page not found.'
    end
    render :show
    #redirect_to tweet_path(@tweet)
  end

end
