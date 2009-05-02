require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  should "set creditor and debtor from email" do
    t = Transaction.new(
      :creditor_email => adam.email,
      :debtor_email => nick.email
    )
    assert_equal adam, t.creditor
    assert_equal nick, t.debtor
    assert_equal adam.email, t.creditor_email
    assert_equal nick.email, t.debtor_email

  end
end
