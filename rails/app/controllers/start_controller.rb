class StartController < ApplicationController
  before_filter :custom_login_required

  def index
  end

  def send_invite
    begin
      email = Email.find(params[:email_id])
      error = "The email address #{email.address} has already been verified." if email.active?
    rescue ActiveRecord::RecordNotFound
      error = "The user could not be found."
    end
    if error.nil?
      UserMailer.deliver_invitation(current_user, email)
      render :json => {:messages => {:success => "An invitation has been sent to #{email.address}"}}
    else
      render :status => 422, :json => {:messages => {:error => "#{error}  An invite has not been sent."}}
    end
  end
end
