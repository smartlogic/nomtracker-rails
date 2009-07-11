var verifiedEmailTemplate = new Template("<img src='/images/check.gif' alt='verified' title='#{email} has been verified' /> <input type='text' name='email' value='#{email}' readonly='readonly' /> <a href='javascript:void(0)' onclick='removeEmail(#{id});'><img src='/images/redex.gif' alt='remove #{email}' title='Click here to remove this email address from your account' /></a>");

var unverifiedEmailTemplate = new Template("<img src='/images/warning.gif' alt='unverified' title='#{email} has not been verified' /> <input type='text' name='email' value='#{email}' readonly='readonly' /> <a href='javascript:void(0)' onclick='removeEmail(#{id});'><img src='/images/redex.gif' alt='remove #{email}' title='Click here to remove this email address from your account' /></a> or <a href='javascript:void(0)' onclick='resendActivationEmail(#{id});'>resend activation email</a>");

function redrawEmails(emails) {
  var html = $A(emails).map(function(email) {
    if (email.verified) {
      return verifiedEmailTemplate.evaluate({email: email.address, id: email.id});
    } else {
      return unverifiedEmailTemplate.evaluate({email: email.address, id: email.id});
    }
  }).join('<br />');
  $('email_addresses').update(html);
}

function resendActivationEmail(email_id) {
  new Ajax.Request('/account/resend_activation', {parameters: 'email_id=' + email_id, 
    onSuccess: function(response) {
      var json = response.responseText.evalJSON();
      updateEmailMessaging(json.messages);
    },
    onFailure: function(response) {
      var json = response.responseText.evalJSON();
      updateEmailMessaging(json.messages);
    }
  });
}

function removeEmail(email_id) {
  if (!confirm("All debts and credits associated with this email address will remain on your account.  Do you still wish to remove this email address?")) {
    return false;
  }
  new Ajax.Request('/account/remove_email', {parameters: 'email_id=' + email_id,
    onSuccess: function(response) {
      var json = response.responseText.evalJSON();
      updateEmailMessaging(json.messages);
      redrawEmails(json['emails']);
    },
    onFailure: function(response) {
      var json = response.responseText.evalJSON();
      updateEmailMessaging(json.messages);
    }
  });
}

function updateEmailMessaging(json) {
  var div = $('email_addresses_messages');
  div.update(Messaging.generate(json));
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
        updateEmailMessaging(json.messages);
      },
      
      onFailure: function(response) {
        var json = response.responseText.evalJSON();
        updateEmailMessaging(json.messages);
      }
    });
  });
});