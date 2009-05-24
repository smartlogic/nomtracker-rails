function openNewTransactionForm() {
	$('open_transaction_form_link').hide();
	$('add_new_transaction').show();
	$('email').focus();
	$('email').select();
}

// related to the nag form
// function displayNagForm() {
//  signup_form = document.getElementById("nag_form_container_container");
//  if (signup_form.style.visibility == 'visible') {
//    signup_form.style.visibility = 'hidden';
//  } else {
//    signup_form.style.visibility = 'visible';
//    document.getElementById('nag_personal_message').focus();
//  }
// }
// // capture the esc key and hide the signup form
// if (document.layers) { document.captureEvents(Event.KEYPRESS); }
// document.onkeypress = getKey;
// function getKey(keyStroke) {
//  var keyCode = (document.layers) ? keyStroke.which : keyStroke.keyCode;
//  if (keyCode == 27) {
//    document.getElementById("nag_form_container_container").style.visibility = 'hidden';
//  }
// }

/***** Above this line comes from Yair's design.  Should eventually all be eliminated. *****/

function finishCreateTransaction(response) {
  var json = response.responseText.evalJSON();
  if (json.update.balances) {
    $('balance_report').update(json.update.balances);
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

function updateGlobals(obj) {
  // Nomworth
  if (obj.nomworth !== undefined) {
    var nomworth = $('nomworth');
    if (obj.nomworth >= 0) {
      nomworth.className = "credit";
    } else {
      nomworth.className = "debt";
      obj.nomworth *= -1;
    }
    $('nomworth').update("$" + obj.nomworth.toFixed(2));
  }
}

var getTodaysDateForNewTransaction = function () {
  var months = new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
  return function() {
    var today = new Date();
    return months[today.getMonth()] + ' ' + today.getDate();
  };
}();

function startNegateBalance(email, amount) {
  openNewTransactionForm();
  $('new_transaction').reset();
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