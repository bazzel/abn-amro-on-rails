// Select or deselect all checkboxes.
function toggleAll() {
  $('#toggle_all').click(function() {
    $(this).closest('form').find(':checkbox').attr('checked', this.checked);
  });
};

jQuery(function($) {
  toggleAll();
});