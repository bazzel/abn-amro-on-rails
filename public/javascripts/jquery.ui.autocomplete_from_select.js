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
    sourceLi = select.parent("li").hide(),
    label    = sourceLi.find("label").html();

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
    
    var targetLi = input.parent("li");
    targetLi.find("label").html(label);
    
    // Formtastic related.
    if (sourceLi.hasClass('required')) {
      targetLi.addClass('required')
        .removeClass('optional');
    }
    
    sourceLi.find('p.inline-errors').appendTo(targetLi);
    // End formtastic related.
    
    input.data("autocomplete")._renderItem = function( ul, item ) {
      return $( "<li></li>" )
      .data( "item.autocomplete", item )
      .append( "<a>" + item.label + "</a>" )
      .appendTo( ul );
    };
  }
});