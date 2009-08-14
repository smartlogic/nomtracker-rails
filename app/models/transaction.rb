# require 'file_column'

class Transaction < ActiveRecord::Base
  include FileColumnHelper

  belongs_to :creditor, :class_name => 'User'
  belongs_to :debtor,   :class_name => 'User'

  file_column :image, :magick => { :geometry => "250x250" }

  validates_presence_of :amount, :creditor_id, :debtor_id
  validates_length_of :when,        :maximum => 50,  :allow_blank => true
  validates_length_of :description, :maximum => 255, :allow_blank => true
  validates_numericality_of :amount, :greater_than => 0.0

  named_scope :to_user, lambda { |user|
    { :conditions => {:debtor_id => user.id} }
  }

  named_scope :from_user, lambda { |user|
    { :conditions => {:creditor_id => user.id} }
  }

  def creditor_email=(email)
    return if email.blank?
    self.creditor = User.find_by_email(email)
    if self.creditor.nil?
      self.creditor = User.create(:email => email)
    end
  end

  def debtor_email=(email)
    return if email.blank?
    self.debtor = User.find_by_email(email)
    if self.debtor.nil?
      self.debtor = User.create(:email => email)
    else
      self.debtor_id = self.debtor.id
    end
  end

  def creditor_email
    return "" if creditor.nil?
    creditor.primary_email.address
  end

  def debtor_email
    return "" if debtor.nil?
    debtor.primary_email.address
  end

  private
    def validate
      puts self.debtor.inspect
      if creditor == debtor
        errors.add :creditor, "and Debtor must be different"
      end
    end

end
