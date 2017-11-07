$(document).ready(function(){
  var promise = getUserData();
  promise.success(function(data) {
    $('input.autocomplete').autocomplete({
      data: data,
      limit: 20
    })
  })
  // getUserData();
  // $.ajax({
  //   url: '/search/user-suggestions',
  //   type: 'GET',
  //   success: function(data) {
  //     console.log(data);
  //     $('input#js-user-autocomplete').autocomplete({
  //       data: data,
  //       limit: 20
  //     })
  //   }
  // })
});

function getUserData() {
  return Promise.resolve($.ajax({
    url: '/search/user-suggestions',
    type: 'GET'
  }));
}
