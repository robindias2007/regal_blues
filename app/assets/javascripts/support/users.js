$(document).ready(function() {
  $("#js-name-fuzzy").on('keyup', function() {
    var query = $(this).val();
    hideAndQueryShow(query);
    containsCaseInsensitive();
  });
});

function hideAndQueryShow(term) {
  $("tr#js-data-row").hide();
  $("tr:contains('" + term + "')").show();
}

function containsCaseInsensitive() {
  $.expr[":"].contains = $.expr.createPseudo(function(arg) {
    return function(elem) {
      return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
    };
  });
}
