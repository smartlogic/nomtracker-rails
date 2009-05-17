class Transaction < ActiveRecord::Base
  belongs_to :creditor, :class_name => 'User'
  belongs_to :debtor,   :class_name => 'User'

  validates_presence_of :amount, :creditor_id, :debtor_id
  validates_length_of :when,        :maximum => 50,  :allow_blank => true
  validates_length_of :description, :maximum => 255, :allow_blank => true
  
  def creditor_email=(email)
    self.creditor = User.find_by_email(email)
    if self.creditor.nil?
      self.creditor = User.create(:email => email)
    end
  end
  
  def debtor_email=(email)
    self.debtor = User.find_by_email(email)
    if self.debtor.nil?
      self.debtor = User.create(:email => email)
    end
  end
  
  def creditor_email
    return "" if creditor.nil?
    creditor.email
  end
  
  def debtor_email
    return "" if debtor.nil?
    debtor.email
  end
  
  private
    def validate
      if creditor == debtor
        errors.add "Creditor", "and Debtor must be different"
      end
    end
    
end
