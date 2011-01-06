$.widget("ui.autocompleteFromGroupedSelect", {
  _create: function() {
    var self = this,
      select = this.element.hide(),
      selected = select.find("option:selected"),
      value = selected.val() ? selected.text() : "",
      id = select.attr('id');
      select.removeAttr('id');
    var input = this.input = $("<input type='text'>")
      .insertAfter(select)
      .val(value)
      // make room for upcoming dropdown button.
      .css('width', '67%')
      .attr('id', id)
      .autocomplete({
        delay: 0,
        minLength: 0,
        source: function(request, response) {
          var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
          response(select.find("option").map(function() {
            var text = $(this).text();
            if (this.value && (!request.term || matcher.test(text))) {
              return {
                label: text.replace(
                  new RegExp(
                    "(?![^&;]+;)(?!<[^<>]*)(" +
                    $.ui.autocomplete.escapeRegex(request.term) +
                    ")(?![^<>]*>)(?![^&;]+;)", "gi"),
                    "<strong>$1</strong>"),
                    value: text,
                    parent: $(this).closest('optgroup').attr('label'),
                    option: this
                  }
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
              // remove invalid value, as it didn't match anything
              $( this ).val("");
              select.val("");
              input.data("autocomplete").term = "";
              return false;
            }
          }
        }
      });

    input.parent('li').addClass('string');
      
    input.data("autocomplete")._renderMenu = function(ul, items) {
      var self = this,
        currentParent = "";
        $.each(items, function(index, item) {
          if (item.parent != currentParent) {
            ul.append("<li class='ui-autocomplete-category'>" + item.parent + "</li>");
            currentParent = item.parent;
          }
          self._renderItem(ul, item);
        });
    };
    input.data("autocomplete")._renderItem = function( ul, item ) {
      return $( "<li></li>" )
        .data( "item.autocomplete", item )
        .append( "<a>" + item.label + "</a>" )
        .appendTo( ul );
    };
    
    this.button = $("<button>&nbsp;</button>")
    .attr("tabIndex", -1)
    .attr("title", "Show All Items")
    .insertAfter(input)
    .button({
      icons: {
        primary: "ui-icon-triangle-1-s"
      },
      text: false
    })
    .removeClass("ui-corner-all")
    .addClass("ui-corner-right ui-button-icon")
    .click(function() {
      // close if already visible
      if (input.autocomplete("widget").is(":visible")) {
        input.autocomplete( "close" );
      } else {
        // pass empty string as value to search for, displaying all results
        input.autocomplete( "search", "" );
        input.focus();
      }
      return false;
    });

  }
});