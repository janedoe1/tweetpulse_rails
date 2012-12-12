class SearchesController < ApplicationController
  before_filter :check_twitter_auth
  before_filter :check_peoplebrowsr_auth
  layout proc {|controller| controller.request.xhr? ? false: "application" }
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
    @search = current_user.searches.find(params[:id])
    #@twitter_users = @search.twitter_users.blank? ? @search.get_twitter_users : @search.twitter_users
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @search.user_to_json }
      format.csv { send_data @search.to_csv, :filename => "#{@search.label} search export - TweetPulse" }
    end
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
      flash[:error] = "#{@search.errors.full_messages.join("\n")}"
      redirect_to new_search_path
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
    flash[:notice] = 'Search was successfully deleted'
    respond_to do |format|
      format.html { redirect_to searches_url }
      format.json { head :no_content }
    end
  end
  
  def refresh_results
    @search = current_user.searches.find(params[:search_id])
    @search.twitter_users.delete_all if @search.twitter_users
    get_api_matches(current_user, @search)
    render :show
  end
  
  protected
  
  def get_api_matches current_user, search
    begin
      search.get_twitter_users(current_user)
    rescue => e
      Rails.logger.info e.message
      flash[:error] = 'API is not responding. Please try again in a few minutes.'
    end
  end
  
end
