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
  
  def invitation(from_user, email)
    setup_email(email.user, email.address)
    @subject += "#{from_user.primary_email.address} has invited you to join Nomtracker"
    @body[:nomtracker_url] = "http://#{SITE_URL}/"
    @body[:url]  = "http://#{SITE_URL}/signup?email=#{email.address}"
    @body[:from_user] = from_user
  end
  
  def transaction_created(user, transaction)
    setup_email(user, user.primary_email.address)
    if transaction.creditor == user
      creating_user = transaction.debtor
      verb = "borrowed"
      to   = "from"
    else
      creating_user = transaction.creditor
      verb = "lent"
      to   = "to"
    end
    @subject += "#{creating_user.name} has added a new debt."
    @body[:creating_user] = creating_user
    @body[:notified_user] = user
    @body[:verb]          = verb
    @body[:to]            = to
    @body[:amount]        = transaction.amount.abs
    @body[:description]   = transaction.description
    @body[:url]           = "http://#{SITE_URL}/"
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
