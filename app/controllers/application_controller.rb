# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem 
  include GlobalUpdates

  helper :all # include all helpers, all the time

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  private
    def custom_login_required
      return true if authorized?
      redirect_to login_path
      return false
    end
    
end
