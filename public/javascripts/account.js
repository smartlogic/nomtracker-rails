var verifiedEmailTemplate = new Template("<img src='/images/check.gif' alt='verified' title='#{email} has been verified' /> <input type='text' name='email' value='#{email}' readonly='readonly' /> <a href='javascript:void(0)' onclick='alert(\"Not implemented\");'><img src='/images/redex.gif' alt='remove #{email}' title='Click here to remove this email address from your account' /></a>");

var unverifiedEmailTemplate = new Template("<img src='/images/warning.gif' alt='unverified' title='#{email} has not been verified' /> <input type='text' name='email' value='#{email}' readonly='readonly' /> <a href='javascript:void(0)' onclick='alert(\"Not implemented\");'><img src='/images/redex.gif' alt='remove #{email}' title='Click here to remove this email address from your account' /></a> or <a href='javascript:void(0)' onclick='alert(\"Not implemented\");'>resend verification email</a>");

function redrawEmails(emails) {
  var html = $A(emails).map(function(email) {
    if (email.verified) {
      return verifiedEmailTemplate.evaluate({email: email.address});
    } else {
      return unverifiedEmailTemplate.evaluate({email: email.address});
    }
  }).join('<br />');
  $('email_addresses').update(html);
}

Event.observe(window, 'load', function() {
  var link = $('add_another_email_link');
  link.observe('click', function(evt) {
    this.hide();
    $('new_email_address').show();
    $('email').focus();
  }.bind(link));
  
  
  $('add_email_button').observe('click', function() {
    new Ajax.Request('/account/add_email', {method: 'post', parameters: {address: $F('email')}, 
      onSuccess: function(response) {
        var json = response.responseText.evalJSON();
        redrawEmails(json['emails']);
        alert(json['messages']['success']);
      },
      
      onFailure: function(response) {
        var json = response.responseText.evalJSON();
        alert(json['messages']['error']);
      }
    });
  });
});