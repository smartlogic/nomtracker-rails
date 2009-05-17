# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def nomworth(user)
    amt = user.nomworth
    klass = amt >= 0 ? "credit" : "debt"
    message = amt >= 0 ? "You're rich!" : "You're a deadbeat!"
    %Q(Your <em>nomworth</em> is <span class="#{klass}">#{number_to_currency(amt.abs)}</span>. #{message})
  end
end
