class AccountController < ApplicationController
  before_filter :custom_login_required
  
  def index
    @email_json = current_user.emails.map{|email| {:address => email.address, :verified => email.verified}}.to_json
  end
  
end