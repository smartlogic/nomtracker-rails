function finishCreateTransaction(response) {
  var json = response.responseText.evalJSON();
  if (json.update.balances) {
    $('balance_report').update(json.update.balances);
  }
  $('new_transaction').reset();
  $('flash').className = "success rounded";
  $('flash').update(json.messages.success);
  $('email').focus();
	$('email').select();
	
  showNeutral();

  updateGlobals(json.update);
}

function failCreateTransaction(response) {
  var json = response.responseText.evalJSON();	
  $('flash').className = 'error rounded';
  $('flash').update(json.messages.error);
	document.location.href="#flash";
}

var getTodaysDateForNewTransaction = function () {
  var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  return function() {
    var today = new Date();
    return months[today.getMonth()] + ' ' + today.getDate();
  };
}();

function startNegateBalance(email, amount) {
  $('new_transaction').reset();
  $('flash').className = 'informational rounded';
  $('flash').update("Please type in a description and press return to clear your balance with " + email);
  $('email').value = email;
  if (amount >= 0.0) {
    $('transaction_type_debt').checked = true;
  } else {
    $('transaction_type_credit').checked = true;
  }
  $('transaction_amount').value = amount.abs();
  $('transaction_when').value = getTodaysDateForNewTransaction();
  $('transaction_description').focus();
}

function updateBalancesMessaging(json) {
  var div = $('balances_messages');
  div.update(Messaging.generate(json));
}

function sendInvitation(email_id, address) {
  if (!confirm("Press ok to send an invitation to " + address + " to join Nomtracker.")) {
    return false;
  }
  new Ajax.Request('/start/send_invite', {parameters: 'email_id=' + email_id, method: 'post', 
    onSuccess: function(response) {
      var json = response.responseText.evalJSON();
      updateBalancesMessaging(json['messages']);
    },
    onFailure: function(response) {
      var json = response.responseText.evalJSON();
      updateBalancesMessaging(json['messages']);
    }
  });
}

function showLent() {
  $('neutral').hide();
  $('borrowed').hide();
  $('lent').show();
}

function showBorrowed() {
  $('neutral').hide();
  $('lent').hide();
  $('borrowed').show();
}

function showNeutral() {
  $('lent').hide();
  $('borrowed').hide();
	$('neutral').show();
}