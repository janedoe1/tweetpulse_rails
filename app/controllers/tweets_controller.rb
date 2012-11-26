class TweetsController < ApplicationController
  
  layout 'application', :except => [:show_tooltip]
  
  
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
	@retweets = @tweet.retweets.blank? ? @tweet.get_retweets(current_user) : @tweet.retweets
	
	if @tweet.retweets.blank?
      flash[:error] = "No retweets for this tweet."
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tweet.to_json }
    end
	
    # begin
    #       @data = @tweet.get_data(current_user)
    #     rescue Twitter::Error::TooManyRequests
    #       flash[:error] = "You have exceeded Twitter's API request limit. Please try again in 15 minutes."
    #       redirect_to search_path(@tweet.search)
    #     end
    #raise @data.inspect
    #data = "[{'name':'flare.analytics.cluster.AgglomerativeCluster','size':3938,'imports':['flare.animate.Transitioner','flare.vis.data.DataList','flare.util.math.IMatrix','flare.analytics.cluster.MergeEdge','flare.analytics.cluster.HierarchicalCluster','flare.vis.data.Data']}]"

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
end
