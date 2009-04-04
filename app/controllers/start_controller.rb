class StartController < ApplicationController
  include AuthenticatedSystem


  def index
    if logged_in?
      logger.debug('logged in')
    end

  end

end
