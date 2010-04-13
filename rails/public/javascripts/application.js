// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var Messaging = {
  error   : new Template("<div class='error rounded'>#{message}</div>"),
  warning : new Template("<div class='warning rounded'>#{message}</div>"),
  info    : new Template("<div class='info rounded'>#{message}</div>"),
  success : new Template("<div class='success rounded'>#{message}</div>"),
  
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

function updateNomworth(amount, owe_you, you_owe) {
  var klass = amount >= 0.0 ? "credit" : "debt";
  var msg   = amount >= 0.0 ? "You're rich!" : "You're a deadbeat!";
  var template = new Template("Your nomworth is: <br/> <span>$#{nomworth}</span> <br/> #{msg}");
	var owe_you_template = new Template("#{owe_you} #{msg} you.");
	var owe_message = owe_you === 1 ? "person owes" : "people owe";
	var you_owe_template = new Template("You owe #{you_owe} #{msg}.");
	var you_owe_message = you_owe === 1 ? "person" : "people";
  $('nomworth').update(template.evaluate({nomworth: amount.abs().toFixed(2), klass: klass, msg: msg }));
	if( amount < 0 ) {
		$('nomworth').addClassName('debt');
	}
	else {
		$('nomworth').removeClassName('debt');
	}
	$('owing').update(you_owe_template.evaluate({you_owe: you_owe, msg: you_owe_message}));
	$('owed').update(owe_you_template.evaluate({owe_you: owe_you, msg: owe_message}));
}

function updateGlobals(obj) {
  // Nomworth
  if (obj.nomworth !== undefined) {
    updateNomworth(obj.nomworth, obj.owe_you, obj.you_owe);
  }
}
