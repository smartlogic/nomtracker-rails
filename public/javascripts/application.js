// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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
  }
}
