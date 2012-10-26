class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authentications }
    end
  end

  # POST /authentications
  # POST /authentications.json
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = current_user.authentications.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      authentication.update_attributes(:token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret'])
      flash[:notice] = "Auth Signed in successfully"
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      if Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
        flash[:error] = "This Twitter account is already a TweetPulse account. Please sign in using that account or authenticate with a different Twitter account."
        redirect_to edit_user_registration_path
      else
        current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret'])
        flash[:notice] = "Curr user Twitter authentication successful"
        redirect_to authentications_url
      end
    else
      user = User.new
      user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret'])
      user.save!
      flash[:notice] = "New User Signed in successfully"
      sign_in_and_redirect(:user, user)
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy

    respond_to do |format|
      format.html { redirect_to authentications_url }
      format.json { head :no_content }
    end
  end
end
