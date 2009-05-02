class StartController < ApplicationController
  include AuthenticatedSystem


  def index
    if !logged_in?
      render :action => 'splash'
      return
    end

    logger.debug('logged in')
    #@transactions = current_user.tra
  end

end
