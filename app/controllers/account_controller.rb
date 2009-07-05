class AccountController < ApplicationController
  before_filter :custom_login_required

  include ActionView::Helpers
  
  def index
    @email_json = prepare_json(current_user.emails).to_json
  end
  
  def add_email
    # first, try to find the email address
    email = Email.find_by_address(params[:address])
    if email && email.user.unregistered?
      # we need to add this existing email address to the current user...
      email.user.transfer_transactions_to(current_user)
      email.user.destroy
      email.user = current_user
    else
      email = Email.new(:address => params[:address], :user => current_user)
    end
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
  
  def resend_activation
    begin
      email = current_user.emails.find(params[:email_id])
      if email.active?
        error = 'This email has already been verified.  An activation request has not been re-sent.'
      end
    rescue ActiveRecord::RecordNotFound
      error = 'This email address does not belong to you. Please try refreshing the page and retrying your request.'
    end
    
    if error.nil?
      UserMailer.deliver_email_activation(email)
      render :json => {
        :messages => {:success => "An activation email has been re-sent to #{email.address}."}
      }
    else
      render :status => 422, :json => {
        :messages => {:error => error}
      }
    end
  end
  
  private
    def prepare_json(email_array)
      email_array.map{|email| {:address => email.address, :verified => email.active?, :id => email.id}}
    end
  
end