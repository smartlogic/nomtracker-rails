var numberOfTransactions = 0;
function openNewTransactionForm() {
	numberOfTransactions++;
	$('open_transaction_form_link').style.display = 'none';
	$('add_new_transaction').style.display = '';
	$('email').focus();
	$('email').select();
}

// function closeNewTransactionForm() {
//  // hide the msgs
//  showhide('successfultransaction', 2);
//  showhide('successfultransactions', 2);
//  // hide the row
//  if (numberOfTransactions == 2) {
//    removeYetAnotherTransaction();
//  } else {
//    numberOfTransactions--;
//    document.getElementById('open_transaction_form_link').style.display = '';
//    document.getElementById('add_new_transaction').style.display = 'none';
//  }
// }
// function addAnotherTransaction() {
//  numberOfTransactions++;
//  document.getElementById('yet_another_transaction').style.display = '';
//  document.getElementById('other_person1').focus();
//  document.getElementById('other_person1').select();
//  document.getElementById('post_transaction_form_link').innerHTML = 'Save these transactions';
// }
// function removeYetAnotherTransaction() {
//  // remove the row
//  numberOfTransactions--;
//  switch (numberOfTransactions) {
//    case 0:
//      // hide everything and go back to the default page state
//    case 1: // yes, I know this will always be the case.  just prototyping the "logic" i suppose
//      document.getElementById('post_transaction_form_link').innerHTML = 'Save this transaction';
//    default:
//      // remove entry numberOfTransactions
//      document.getElementById('yet_another_transaction').style.display = 'none';
//      // focus/select the (numberOfTransactions - 1)th description field
//      document.getElementById('description').focus();
//      document.getElementById('description').select();
//  }
// }
// function showhide(elid) {
//  elt = document.getElementById(elid);
//  showorhide = arguments.length > 1 ? arguments[1] : 0;
//  switch (showorhide) {
//    case 0:   // toggle
//      elt.style.display = elt.style.display == '' ? 'none' : '';
//      break;
//    case 1:   // show
//      elt.style.display = '';
//      break;
//    case 2:   // hide
//      elt.style.display = 'none';
//  }
// }

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
  if (json.update.credits) {
    $('credit_report').update(json.update.credits);
  } else if (json.update.debits) {
    $('debt_report').update(json.update.debts);      
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

function setPageError(msg) {
  alert('Display the message: ' + msg);
}