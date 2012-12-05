// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.qtip
//= require twitter/bootstrap
//= require d3.v2
//= require bootstrap-datepicker
//= require_tree .

function defaultAjaxErrorHandler(result, isAjaxError) {
  // do stuff, hide spinner etc...
  // var defaultAjaxError = "Your friendly error message";
  // var errorToken = "Error:";
  //alert(result.responseText);
  $('#loading-overlay').html(result.responseText);
  $('#loading-overlay').attr('class', 'alert alert-danger');
  $('#loading-overlay').delay(4000).fadeOut(2000);
  // if(!isUndefinedOrNull(result) && !isUndefinedOrNull(result.responseText)) {
  //     // localhost
  //     var x = (result.responseText.length > 350) ? 350 : result.responseText.length;
  //     alert(result.responseText.substring(0, x) + "...\n\n  - Check firebug console for more info.\n  - This message for localhost only.");
  // }
  // else {
  //   // production error
  //   alert(defaultAjaxError); 
  // }
}

function isUndefinedOrNull(x) {
  var u; // undefined var
  if(x === u) { // similar to [typeof x == "undefined"]
    return true;
  }
  // else
  return x === null;
}