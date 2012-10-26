class KeywordTermsController < ApplicationController
  # GET /keyword_terms
  # GET /keyword_terms.json
  def index
    @keyword_terms = KeywordTerm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @keyword_terms }
    end
  end

  # GET /keyword_terms/1
  # GET /keyword_terms/1.json
  def show
    @keyword_term = KeywordTerm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @keyword_term }
    end
  end

  # GET /keyword_terms/new
  # GET /keyword_terms/new.json
  def new
    @keyword_term = KeywordTerm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @keyword_term }
    end
  end

  # GET /keyword_terms/1/edit
  def edit
    @keyword_term = KeywordTerm.find(params[:id])
  end

  # POST /keyword_terms
  # POST /keyword_terms.json
  def create
    @keyword_term = KeywordTerm.new(params[:keyword_term])

    respond_to do |format|
      if @keyword_term.save
        format.html { redirect_to @keyword_term, notice: 'Keyword term was successfully created.' }
        format.json { render json: @keyword_term, status: :created, location: @keyword_term }
      else
        format.html { render action: "new" }
        format.json { render json: @keyword_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /keyword_terms/1
  # PUT /keyword_terms/1.json
  def update
    @keyword_term = KeywordTerm.find(params[:id])

    respond_to do |format|
      if @keyword_term.update_attributes(params[:keyword_term])
        format.html { redirect_to @keyword_term, notice: 'Keyword term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @keyword_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keyword_terms/1
  # DELETE /keyword_terms/1.json
  def destroy
    @keyword_term = KeywordTerm.find(params[:id])
    @keyword_term.destroy

    respond_to do |format|
      format.html { redirect_to keyword_terms_url }
      format.json { head :no_content }
    end
  end
end
