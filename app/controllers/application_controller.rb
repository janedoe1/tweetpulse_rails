class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  rescue_from Exception, :with => :handler_exception
  
  def check_twitter_auth
    unless !!current_user.authentications.find_by_provider('twitter')
      flash[:error] = "You must authenticate with Twitter before creating searches."
      redirect_to edit_user_registration_path
    end
  end
  
  def handler_exception(exception)
    if request.xhr?
      if exception.class == Twitter::Error::TooManyRequests
        message = "Twitter API limit reached. Please try again in a few minutes."
      else
        message = "Error: #{exception.class.to_s}"
        message += " in #{request.parameters['controller'].camelize}Controller" if request.parameters['controller']
        message += "##{request.parameters['action']}" if request.parameters['action']
        message += "\n\nRequest:\n#{params.inspect.gsub(',', ",\n")}"
      end
      # log the error
      logger.fatal "#{message}"
      #message = "ajaxError, check the server logs for details"
      respond_to do |want|
        want.js { render :text => message, :status => :internal_server_error  }
      end
    else
      # not an ajax request, use the default handling; 
      # actionpack-2.2.2/lib/action_controller/rescue.rb
      rescue_action_without_handler(exception) 
    end
    return # don't risk DoubleRenderError
  end
end
