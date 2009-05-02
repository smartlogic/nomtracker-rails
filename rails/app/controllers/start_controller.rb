class StartController < ApplicationController
  before_filter :custom_login_required

  def index
    logger.debug('logged in')
  end
end
