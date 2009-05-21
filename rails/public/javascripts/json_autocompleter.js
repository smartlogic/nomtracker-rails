
Ajax.JsonAutocompleter = Class.create(Ajax.Autocompleter, {
  onComplete : function(response) {
    var json = response.responseText.evalJSON();
    var list = "";
    if (json.emails.size() > 0) {
      list = "<ul>";
      json.emails.each(function(email) {
        list += "<li>" + email + "</li>";
      });
      list += "</ul>";
    }
    this.updateChoices(list);
  }
});