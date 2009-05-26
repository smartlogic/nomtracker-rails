module TransactionsHelper
  
  def to_sentence(txn)
    if txn.amount > 0
      "<em>You</em> lent #{h txn.other_person.email}"
    else
      "#{h txn.other_person.email} lent <em>you</em>"
    end
  end
  
  def full_description(txn)
    ret = ""
    ret << " on #{txn.when}" unless txn.when.blank?
    ret << " for #{txn.description}" unless txn.description.blank?
    ret
  end
  
end
