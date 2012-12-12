class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
  end
  
  def new
    @authentication = Authentication.new
  end
  
  # POST /authentications
  # POST /authentications.json
  def create
    omniauth = request.env["omniauth.auth"]
    if omniauth
      authentication = current_user.authentications.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      if authentication
        authentication.update_attributes(:token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret'])
        flash[:notice] = "Signed in successfully"
        sign_in_and_redirect(:user, authentication.user)
      elsif current_user
        if Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
          flash[:error] = "This Twitter account is already associated with a TweetPulse account. Please sign in using that account or authenticate with a different Twitter account."
          redirect_to edit_user_registration_path
        else
          current_user.authentications.create!(:provider          => omniauth['provider'],
                                               :uid               => omniauth['uid'], 
                                               :token             => omniauth['credentials']['token'],
                                               :secret            => omniauth['credentials']['secret'],
                                               :username          => omniauth['extra']['raw_info']['screen_name'],
                                               :profile_image_url => omniauth['extra']['raw_info']['profile_image_url'])
          flash[:notice] = "Twitter authentication successful"
          redirect_to edit_user_registration_path
        end
      else
        user = User.new
        user.authentications.build(:provider          => omniauth['provider'],
                                   :uid               => omniauth['uid'], 
                                   :token             => omniauth['credentials']['token'],
                                   :secret            => omniauth['credentials']['secret'],
                                   :username          => omniauth['extra']['raw_info']['screen_name'],
                                   :profile_image_url => omniauth['extra']['raw_info']['profile_image_url'])
        user.save!
        flash[:notice] = "Signed in successfully"
        sign_in_and_redirect(:user, user)
      end
    else
      @authentication = current_user.authentications.new(params[:authentication])
      if @authentication.save
        @authentication.update_attributes(:provider => 'peoplebrowsr')
        flash[:notice] = 'PeopleBrowsr authentication successful'
        redirect_to edit_user_registration_path
      else
        Rails.logger.debug @authentication.errors.full_messages.join("\n")
        flash[:error] = "There was an error authenticating with PeopleBrowsr. Please try again"
        redirect_to edit_user_registration_path
      end
    end
  end
  
  def update
    @authentication = current_user.authentications.find(params[:id])
    if @authentication.update_attributes(params[:authentication])
      flash[:notice] = 'Authentication was successfully updated.'
      redirect_to edit_user_registration_path
    else
      flash[:error] = "There was an error updating the authentication"
      redirect_to edit_user_registration_path
    end
  end
  
  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Service deauthorized"
    redirect_to edit_user_registration_path
  end
end
