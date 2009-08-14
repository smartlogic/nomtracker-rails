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

  def balances
    render :xml => current_user.iphone_balances
  end

  def emails
    render :xml => Email.find(:all, :conditions => ["address NOT IN (?)", current_user.emails.map(&:address)]).to_xml(:only => :address)
  end

  def transactions_with_user
    if params[:id] == current_user.id
      render :xml => []
    else
      render :xml => current_user.transactions_with(params[:id])
    end
  end

end
