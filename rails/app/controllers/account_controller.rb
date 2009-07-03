class AccountController < ApplicationController
  before_filter :custom_login_required

  include ActionView::Helpers
  
  def index
    @email_json = prepare_json(current_user.emails).to_json
  end
  
  def add_email
    email = Email.new(:address => params[:address], :user => current_user)
    if email.save
      UserMailer.deliver_email_activation(email)
      render :json => {
        :emails => prepare_json(current_user.emails(true)),
        :messages => {:success => "The addition of the email address #{email.address} to your account is pending.  An email containing an activation link has been sent to #{email.address}."}
      }
    else
      render :status => 422, :json => {
        :messages => {:error => escape_javascript(email.errors.full_messages.join('<br/>'))}
      }
    end
  end
  
  private
    def prepare_json(email_array)
      email_array.map{|email| {:address => email.address, :verified => email.active?}}
    end
  
end