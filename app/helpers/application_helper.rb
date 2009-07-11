# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_user(user)
    ret = h(user.primary_email.address)
    if !user.active?
      alt = "#{user.primary_email.address} has not yet established an account"
      ret += link_to(image_tag('warning.gif', :alt => alt), 'javascript:void(0)', 
        :onclick => 'alert("Bring up form to allow them to send an email to this person imploring them to join Nomtracker: server side is implemented, but client side is unimplemented");', :title => 'Send an email asking this person to join Nomtracker')
    end
    ret
  end
end
