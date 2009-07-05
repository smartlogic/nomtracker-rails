// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var Messaging = {
  error   : new Template("<div class='error'>#{message}</div>"),
  warning : new Template("<div class='warning'>#{message}</div>"),
  info    : new Template("<div class='info'>#{message}</div>"),
  success : new Template("<div class='success'>#{message}</div>"),
  
  generate : function(json) {
    var html = "";
    if (json) {
      if (json.error) {
        html += Messaging.error.evaluate({message: json.error});
      }
      if (json.success) {
        html += Messaging.success.evaluate({message: json.success});
      }
      if (json.warning) {
        html += Messaging.warning.evaluate({message: json.warning});
      }
      if (json.info) {
        html += Messaging.info.evaluate({message: json.info});
      }
    }
    return html;
  }
};

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
