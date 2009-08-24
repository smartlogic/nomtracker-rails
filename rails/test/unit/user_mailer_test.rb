require File.dirname(__FILE__) + '/../test_helper'
require 'user_mailer'

class UserMailerTest < ActiveSupport::TestCase
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end

  def test_signup_notification
    u = User.new(:name => 'John', :email => 'john@slsdev.net', :password => 'johnjohn', :password_confirmation => 'johnjohn')
    u.user_state = 'pending'
    u.save!
    assert_nothing_raised { UserMailer.deliver_signup_notification(u) }
  end
  
  def test_send_activation_email
    u = User.create_and_activate(:name => 'John', :email => 'john@slsdev.net', :password => 'johnjohn', :password_confirmation => 'johnjohn')
    assert_nothing_raised { UserMailer.deliver_activation(u, 'john@slsdev.net') }
  end
  
  def test_email_activation
    new_address = "nick2@slsdev.net"
    email = nick.emails.create!(:address => new_address)
    assert_nothing_raised { UserMailer.deliver_email_activation(email) }
  end
  
  def test_email_activation_confirmation
    new_address = "nick2@slsdev.net"
    email = nick.emails.create!(:address => new_address)
    assert_nothing_raised { UserMailer.deliver_email_activation_confirmation(email) }
  end
  
  def test_invitation
    john = User.create!(john_attrs)
    assert_nothing_raised { UserMailer.deliver_invitation(nick, john.primary_email) }
  end
  
  def test_new_transaction_notification
    trans = Transaction.create!(:creditor => nick, :debtor => adam, :amount => 5)
    assert_nothing_raised { UserMailer.deliver_transaction_created(nick, trans) }
  end

  private

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
