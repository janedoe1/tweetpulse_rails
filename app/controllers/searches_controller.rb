class SearchesController < ApplicationController
  before_filter :check_twitter_auth
#  before_filter :build_gexf, :only => :show
  # GET /searches
  # GET /searches.json
  def index
    @searches = current_user.searches

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @searches }
    end
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    #@search = current_user.searches.find(params[:id])
    #@tweets = @search.tweets.blank? ? @search.get_tweets : @search.tweets
    #if @search.tweets.blank?
    #  flash[:error] = "No tweets matched this search."
    #  #redirect_to searches_path
    #end
	#respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render json: @search.to_json }
    #end
	
	@search = current_user.searches.find(params[:id])
    @tweets = @search.TwitterUsers.blank? ? @search.get_twitter_users : @search.TwitterUsers
    if @search.TwitterUsers.blank?
      flash[:error] = "No users matched this search."
      #redirect_to searches_path
    end
	respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @search.user_to_json }
    end
	#@users =  @search.get_users
	#flash[:error] = @search.get_twitter_users
	 
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render json: @search.TwitterUsers }
    #end
	
  end

  # GET /searches/new
  # GET /searches/new.json
  def new
    @search = Search.new
    @terms = []
    [KeywordTerm, HashtagTerm, UserTerm].each do |type|
      @terms.push(@search.terms.build(:type => type))
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @search }
    end
  end

  # GET /searches/1/edit
  def edit
    @search = current_user.searches.find(params[:id])
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = current_user.searches.new(params[:search])
    if @search.save
      flash[:notice] = 'Search was successfully created.'
      redirect_to @search
    else
      Rails.logger.debug @search.errors.full_messages.join("\n")
      flash[:error] = 'Search was not created.'
      redirect_to dashboard_path
    end
  end

  # PUT /search/1
  # PUT /search/1.json
  def update
    @search = current_user.searches.find(params[:id])

    respond_to do |format|
      if @search.update_attributes(params[:search])
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search = current_user.searches.find(params[:id])
    @search.destroy

    respond_to do |format|
      format.html { redirect_to searches_url }
      format.json { head :no_content }
    end
  end
  
  def refresh_results
    @search = current_user.searches.find(params[:search_id])
    @search.tweets.destroy_all
    begin
      @search.get_tweets
    rescue Twitter::Error::InternalServerError => e
      puts e
      Rails.logger.info e.message
      flash[:error] = 'Twitter is not responding. Please try again in a few minutes.'
    end
    redirect_to search_path(@search)
  end
  
  protected
  
  
end
