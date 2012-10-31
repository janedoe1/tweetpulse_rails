class TermsController < ApplicationController
  before_filter :check_twitter_auth
  # GET /terms
  # GET /terms.json
  def index
    @terms = current_user.terms

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @terms }
    end
  end

  # GET /terms/1
  # GET /terms/1.json
  def show
    @term = current_user.terms.find(params[:id])
    @tweets = @term.tweets.blank? ? @term.get_tweets : @term.tweets
  end

  # GET /terms/new
  # GET /terms/new.json
  def new
    @search = Search.new
    3.times {@search.terms.build}
  end

  # GET /terms/1/edit
  def edit
    @term = current_user.terms.find(params[:id])
  end

  # POST /terms
  # POST /terms.json
  def create
    raise
    @term = current_user.terms.new(params[:term])

    respond_to do |format|
      if @term.save
        format.html { redirect_to @term, notice: 'Term was successfully created.' }
        format.json { render json: @term, status: :created, location: @term }
      else
        format.html { render action: "new" }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /terms/1
  # PUT /terms/1.json
  def update
    @term = current_user.terms.find(params[:id])

    respond_to do |format|
      if @term.update_attributes(params[:term])
        format.html { redirect_to @term, notice: 'Term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terms/1
  # DELETE /terms/1.json
  def destroy
    @term = current_user.terms.find(params[:id])
    @term.destroy

    respond_to do |format|
      format.html { redirect_to terms_url }
      format.json { head :no_content }
    end
  end
  
  # def refresh_results
  #   @term = current_user.terms.find(params[:term_id])
  #   @term.tweets.destroy_all
  #   @term.get_tweets
  #   redirect_to term_path(@term)
  # end
  
end
