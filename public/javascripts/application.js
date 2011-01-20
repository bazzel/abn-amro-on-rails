// Select or deselect all checkboxes.
function toggleAll() {
  $('#toggle_all').click(function() {
    $(this).closest('form').find(':checkbox').attr('checked', this.checked);
  });
};

// Displays action links in table tows when hovering over them.
function hoverRowActions() {
  // var rowActions = $('.row-actions').hide();
  var rowActions = $('.row-actions').css({visibility: "hidden"});
  
  rowActions.closest('tr').hover(function() {
    $(this).find('.row-actions').css({visibility: "visible"});
  },
  function() {
    $(this).find('.row-actions').css({visibility: "hidden"})
  });
};

function tabs() {
  $('.tabs').tabs('.panes > div', {
    tabs: 'a.tab'
  });
}

jQuery(function($) {
  toggleAll();
  hoverRowActions();
  tabs();
});
