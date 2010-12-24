$(function() {
  $.widget("ui.autocompleteFromSelect", {
    options: {
      source: ""
    },
    _create: function() {
      var self   = this,
        o        = self.options,
        select   = $(o.source).hide(),
        selected = select.children(":selected"),
        value    = selected.val() ? selected.text() : "",
        label    = select.parent("li").hide().find("label").text();

        var input = this.element
          .val(value)
          .autocomplete({
              delay: 0,
              minLength: 0,
              source: function(request, response) {
                var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
                response(select.children("option").map(function() {
                  var text = $(this).text();
                  if (this.value && (!!request.term && matcher.test(text)))
                  return {
                    label: text.replace(
                      new RegExp(
                        "(?![^&;]+;)(?!<[^<>]*)(" +
                        $.ui.autocomplete.escapeRegex(request.term) +
                        ")(?![^<>]*>)(?![^&;]+;)", "gi"),
                      "<strong>$1</strong>"),
                    value: text,
                    option: this
                  }
                })
              );
            },
            select: function(event, ui) {
              ui.item.option.selected = true;
            },
            change: function(event, ui) {
              if (!ui.item) {
                var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex($(this).val()) + "$", "i"),
                valid = false;
                select.children("option").each(function() {
                  if (this.value.match(matcher)) {
                    this.selected = valid = true;
                    return false;
                  }
                });
                if (!valid) {
                  select.val("");
                  return false;
                }
              }
            }
          });
          input.parent("li").find("label").text(label);
          input.data("autocomplete")._renderItem = function( ul, item ) {
            return $( "<li></li>" )
              .data( "item.autocomplete", item )
              .append( "<a>" + item.label + "</a>" )
              .appendTo( ul );
          };
    }
  });
});