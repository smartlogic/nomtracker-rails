class UsersController < ApplicationController

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    # does the user exist?
    @user = User.find_by_email(params[:user][:email])
    if @user
      if @user.pending?
        @user.attributes = params[:user]
        @user.user_state = 'active'
        if @user.save
          finish_create
        else
          render :action => 'new'
        end
      elsif @user.active?
        @user = User.new(:email => params[:email])
        @user.valid?
        render :action => 'new'
      end
      return
    end
    
    @user = User.new(params[:user])
    @user.user_state = 'active'
    success = @user && @user.save
    if success && @user.errors.empty?
      finish_create
    else
      render :action => 'new'
    end
  end
  
  private
    def finish_create
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    end
end
