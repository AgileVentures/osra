$(function(){
  $("#filters").hide();

  $("#btn-filters-toggle").click(function(){
    $("#btn-filters-toggle>span").toggleClass("th_sort_desc");
    $("#btn-filters-toggle>span").toggleClass("th_sort_asc");
    // $("#filters").animate({width: 'toggle'});
    $("#filters").toggle("fast");
  })
})