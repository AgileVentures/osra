$(document).ready(function(){
  $("input[required]").parent().children("label").append("<span class=\"mandatory-field\">*</span>");
});