$(document).ready(function() {
  $('input#js-user-autocomplete').on('click', function() {
    getUserData().done(function(data) {
      userAutocomplete(data);
    });
  })

  $('input#js-designer-autocomplete').on('click', function() {
    getDesignerData().done(function(data) {
      designerAutocomplete(data);
    });
  })
});

function userAutocomplete(data) {
  $('input#js-user-autocomplete').autocomplete({
    data: data,
    limit: 10
  });
}

function getUserData() {
  return $.get('search/user-suggestions');
}

function designerAutocomplete(data) {
  $('input#js-designer-autocomplete').autocomplete({
    data: data,
    limit: 20
  });
}

function getDesignerData() {
  return $.get('search/designer-suggestions');
}
