class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def find
    email_arg = params[:email]
    @users = current_user.network.select {|email| email =~ Regexp.new("#{email_arg}")}
    render :json => {:emails => @users}
  end
  
  def create
    logout_keeping_session!
    # does the user exist?
    @user = User.find_by_email(params[:user][:email])
    if @user && @user.unregistered?
      @user.attributes = params[:user].reject{|field, value| field == 'email'}
      @user.user_state = 'pending'
    else
      @user = User.new(params[:user])
      @user.user_state = 'pending'
    end

    if @user && @user.save && @user.errors.empty?
      UserMailer.deliver_signup_notification(@user)
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code.  Please click the link in that email to confirm your account."
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
  
  def activate
    logout_keeping_session!
    email = Email.find_by_activation_code(params[:activation_code], :include => :user) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && email && email.pending?
      email.activate!
      if email.user.pending?
        UserMailer.deliver_activation(email.user, email.address)
        email.user.activate! 
        flash[:notice] = "Signup complete! You can now start tracking your debts."
      else
        UserMailer.deliver_email_activation_confirmation(email)
        flash[:notice] = "#{email.address} has been added to your account!"
      end
      session[:user_id] = email.user.id
      redirect_to root_url
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
end
