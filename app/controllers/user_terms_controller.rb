class UserTermsController < ApplicationController
  # GET /user_terms
  # GET /user_terms.json
  def index
    @user_terms = UserTerm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_terms }
    end
  end

  # GET /user_terms/1
  # GET /user_terms/1.json
  def show
    @user_term = UserTerm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_term }
    end
  end

  # GET /user_terms/new
  # GET /user_terms/new.json
  def new
    @user_term = UserTerm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_term }
    end
  end

  # GET /user_terms/1/edit
  def edit
    @user_term = UserTerm.find(params[:id])
  end

  # POST /user_terms
  # POST /user_terms.json
  def create
    @user_term = UserTerm.new(params[:user_term])

    respond_to do |format|
      if @user_term.save
        format.html { redirect_to @user_term, notice: 'User term was successfully created.' }
        format.json { render json: @user_term, status: :created, location: @user_term }
      else
        format.html { render action: "new" }
        format.json { render json: @user_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_terms/1
  # PUT /user_terms/1.json
  def update
    @user_term = UserTerm.find(params[:id])

    respond_to do |format|
      if @user_term.update_attributes(params[:user_term])
        format.html { redirect_to @user_term, notice: 'User term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_terms/1
  # DELETE /user_terms/1.json
  def destroy
    @user_term = UserTerm.find(params[:id])
    @user_term.destroy

    respond_to do |format|
      format.html { redirect_to user_terms_url }
      format.json { head :no_content }
    end
  end
end
