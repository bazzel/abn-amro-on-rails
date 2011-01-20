// Select or deselect all checkboxes.
function toggleAll() {
  $('#toggle_all').click(function() {
    $(this).closest('form').find(':checkbox').attr('checked', this.checked);
  });
};

// Apply jQuery Tools tabs.
// http://flowplayer.org/tools.
function tabs() {
  $('.tabs').tabs('.panes > div', {
    tabs: 'a.tab'
  });
}

jQuery(function($) {
  toggleAll();
  tabs();
});
