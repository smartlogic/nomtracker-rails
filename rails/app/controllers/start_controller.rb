class StartController < ApplicationController
  before_filter :custom_login_required

  def index
    logger.debug('logged in')
    #@transactions = current_user.tra
  end
  
  private
    def custom_login_required
      return true if authorized?
      render :action => 'splash'
      return false
    end

end
