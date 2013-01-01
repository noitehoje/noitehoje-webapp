function getPosition(callback) {
  if(navigator.geolocation) { // Try W3C Geolocation method (Preferred)
    navigator.geolocation.getCurrentPosition(function(position) {
      callback({
        location: new google.maps.LatLng(position.coords.latitude,position.coords.longitude),
        provider: "W3C standard",
        success: true
      });
    }, function() {
        callback({
            success: false,
            errorMsg: "Error: The Geolocation service failed."
        });
    },{ timeout: 5000 });
  }
  else {
    // Browser doesn't support Geolocation
    callback({
        success: false,
        errorMsg: "Error: Your browser doesn't support geolocation."
    });
  }
}

function setupMap(data) {
    if(data.success) {
        var options = {
            zoom: 16,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        resizeMap();

        var map = new google.maps.Map(document.getElementById('map_canvas'), options);
        map.setCenter(data.location);

        var marker = new google.maps.Marker({
            position: data.location,
            map: map,
            title: data.title
        });

        var infowindow = new google.maps.InfoWindow({
          content: '<p>' + data.title + '</p>'
        });

        google.maps.event.addListener(marker, 'click', function() {
          infowindow.open(map, marker);
        });
    }
    else {
        alert(data.errorMsg);
    }
}

function resizeMap() {
    var mapdiv = $("#map_canvas");
    var windowWidth = $(window).width();
    var windowHeight = $(window).height();

    mapdiv.width(windowWidth);
    mapdiv.height(windowHeight - 15 - 43);
}
