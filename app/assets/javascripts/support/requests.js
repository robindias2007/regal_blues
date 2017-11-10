$(document).ready(function() {
  $('#js-approve-request > i').on('click', function() {
    var requestId = $(this).data('id');
    Rails.ajax({
      url: '/requests/' + requestId + '/approve',
      type: 'PATCH',
      beforeSend: function() {
        return true
      },
      success: function(data) {
        console.log(data);
        Materialize.toast(data.message, 4000, 'toast-flash toast-success')
      },
      error: function(data) {
        Materialize.toast(data.responseJSON.message, 4000, 'toast-flash toast-error')
      }
    });
  })
});
