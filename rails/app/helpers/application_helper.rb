# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_user(user)
    ret = h(user.primary_email.address)
    if !user.active?
      alt = "#{user.primary_email.address} has not yet established an account"
      ret += link_to(image_tag('warning.gif', :alt => alt), 'javascript:void(0)', 
        :onclick => "sendInvitation(#{user.primary_email.id}, '#{escape_javascript(user.primary_email.address)}');", :title => "Send a Nomtracker invitation to #{h user.primary_email.address}")
    end
    ret
  end
end
