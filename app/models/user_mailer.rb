class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  
  end
  
  def activation(user, email)
    setup_email(user, email)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  protected
    def setup_email(user, email=user.primary_email)
      @recipients  = email
      @from        = "no-reply@nomtracker.com"
      @subject     = "[nomtracker] "
      @sent_on     = Time.now
      @body[:user]  = user
      @body[:email] = email
    end
end
