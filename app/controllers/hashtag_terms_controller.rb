class HashtagTermsController < ApplicationController
  # GET /hashtag_terms
  # GET /hashtag_terms.json
  def index
    @hashtag_terms = HashtagTerm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hashtag_terms }
    end
  end

  # GET /hashtag_terms/1
  # GET /hashtag_terms/1.json
  def show
    @hashtag_term = HashtagTerm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hashtag_term }
    end
  end

  # GET /hashtag_terms/new
  # GET /hashtag_terms/new.json
  def new
    @hashtag_term = HashtagTerm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hashtag_term }
    end
  end

  # GET /hashtag_terms/1/edit
  def edit
    @hashtag_term = HashtagTerm.find(params[:id])
  end

  # POST /hashtag_terms
  # POST /hashtag_terms.json
  def create
    @hashtag_term = HashtagTerm.new(params[:hashtag_term])

    respond_to do |format|
      if @hashtag_term.save
        format.html { redirect_to @hashtag_term, notice: 'Hashtag term was successfully created.' }
        format.json { render json: @hashtag_term, status: :created, location: @hashtag_term }
      else
        format.html { render action: "new" }
        format.json { render json: @hashtag_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hashtag_terms/1
  # PUT /hashtag_terms/1.json
  def update
    @hashtag_term = HashtagTerm.find(params[:id])

    respond_to do |format|
      if @hashtag_term.update_attributes(params[:hashtag_term])
        format.html { redirect_to @hashtag_term, notice: 'Hashtag term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hashtag_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hashtag_terms/1
  # DELETE /hashtag_terms/1.json
  def destroy
    @hashtag_term = HashtagTerm.find(params[:id])
    @hashtag_term.destroy

    respond_to do |format|
      format.html { redirect_to hashtag_terms_url }
      format.json { head :no_content }
    end
  end
end
