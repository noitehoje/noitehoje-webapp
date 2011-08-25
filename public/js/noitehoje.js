$('div').live('pagehide',function(event, ui){
  if($(ui.nextPage).attr('id') == '/show/2/mapa') {
    createMap({
      location: new google.maps.LatLng(-30.0253668, -51.2123221),
      title: 'Apolinário Pub Porto Alegre',
      success: true
    });
  }
});

$(window).resize(function() {
  resizeMap();
});

//$(document).bind("mobileinit", function(){
//getPosition(doStuff);
//});

