$("#js-name-fuzzy").keyup(function(){
    $("li").hide();
   var term = $(this).val();
    $("li:contains('" + term + "')").show();
});
