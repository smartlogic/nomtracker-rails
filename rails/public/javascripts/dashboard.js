function updateNomworth(amount) {
  var klass = amount >= 0.0 ? "credit" : "debt";
  var msg   = amount >= 0.0 ? "You're rich!" : "You're a deadbeat!";
  var template = new Template("Welcome to nomtracker. Your <em>nomworth</em> is <span id='nomworth' class='#{klass}'>$#{nomworth}</span>. #{msg}");
  $('welcome_message').update(template.evaluate({nomworth: amount.abs().toFixed(2), klass: klass, msg: msg }));
}

function updateGlobals(obj) {
  // Nomworth
  if (obj.nomworth !== undefined) {
    updateNomworth(obj.nomworth);
    // var nomworth = $('nomworth');
    // if (obj.nomworth >= 0) {
    //   nomworth.className = "credit";
    // } else {
    //   nomworth.className = "debt";
    //   obj.nomworth *= -1;
    // }
    // $('nomworth').update("$" + obj.nomworth.toFixed(2));
  }
}

function openNewTransactionForm() {
	$('open_transaction_form_link').hide();
	$('add_new_transaction').show();
	$('email').focus();
	$('email').select();
}

function finishCreateTransaction(response) {
  var json = response.responseText.evalJSON();
  if (json.update.balances) {
    $('balance_report').update(json.update.balances);
  }
  if (json.update.transactions) {
    $('recent_transactions_report').update(json.update.transactions);
  }
  $('new_transaction').reset();
  $('new_transaction_flash').className = "success";
  $('new_transaction_flash').update(json.messages.success);
  $('email').focus();
	$('email').select();
  
  updateGlobals(json.update);
}

function failCreateTransaction(response) {
  var json = response.responseText.evalJSON();
  $('new_transaction_flash').className = 'error';
  $('new_transaction_flash').update(json.messages.error);
}

var getTodaysDateForNewTransaction = function () {
  var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  return function() {
    var today = new Date();
    return months[today.getMonth()] + ' ' + today.getDate();
  };
}();

function startNegateBalance(email, amount) {
  openNewTransactionForm();
  $('new_transaction').reset();
  $('new_transaction_flash').className = 'informational';
  $('new_transaction_flash').update("Please type in a description and press return to clear your balance with " + email);
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
