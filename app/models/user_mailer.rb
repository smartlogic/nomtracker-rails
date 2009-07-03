class UserMailer < ActionMailer::Base

  # For creating a new account
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.primary_email.activation_code}"
  end
      
  # For creating a new account -- confirms the activation of the account and the primary email address
  def activation(user, email)
    setup_email(user, email)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  # For activating a new email address -- sends the link to actually activate the email address
  def email_activation(email)
    setup_email(email.user, email.address)
    @subject    += 'Please verify your email address'
    @body[:url]  = "http://#{SITE_URL}/activate/#{email.activation_code}"
  end
  
  # After activating a new email, this email confirms it
  def email_activation_confirmation(email)
    setup_email(email.user, email.address)
    @subject    += 'A new email address has been activated'
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  protected
    def setup_email(user, email=user.primary_email.address)
      @recipients  = email
      @from        = "no-reply@nomtracker.com"
      @subject     = "[nomtracker] "
      @sent_on     = Time.now
      @body[:user]  = user
      @body[:email] = email
    end
end
