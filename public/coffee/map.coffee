NOITEHOJE.webApp.googleMaps = (() ->
  CITIES_LOCATIONS:
    "porto-alegre": new google.maps.LatLng(-30.027704, -51.228735)
    "curitiba": new google.maps.LatLng(-25.428356,-49.273251)
    "rio-de-janeiro": new google.maps.LatLng(-22.903539,-43.209587)
    "sao-paulo": new google.maps.LatLng(-23.548943,-46.638818)
    "belo-horizonte": new google.maps.LatLng(-19.919068,-43.938575)
    "florianopolis": new google.maps.LatLng(-27.596904,-48.549454)
  showMarker:
    image: new google.maps.MarkerImage(
      '/images/app/show-map-icon.png',
      new google.maps.Size(48,48),
      new google.maps.Point(0,0),
      new google.maps.Point(24,48))
    shadow: new google.maps.MarkerImage(
      '/images/app/show-map-icon-shadow.png',
      new google.maps.Size(76,48),
      new google.maps.Point(0,0),
      new google.maps.Point(24,48))
    selected: new google.maps.MarkerImage(
      '/images/app/show-map-icon-selected.png',
      new google.maps.Size(48,48),
      new google.maps.Point(0,0),
      new google.maps.Point(24,48))
    shape:
      coord: [43,0,44,1,44,2,44,3,44,4,44,5,44,6,44,7,44,8,44,9,44,10,44,11,44,12,44,13,44,14,44,15,44,16,44,17,44,18,44,19,44,20,44,21,44,22,44,23,44,24,44,25,44,26,44,27,44,28,44,29,44,30,44,31,44,32,44,33,44,34,44,35,44,36,44,37,44,38,44,39,44,40,43,41,29,42,28,43,27,44,26,45,25,46,24,47,23,47,22,46,21,45,20,44,19,43,18,42,4,41,3,40,3,39,3,38,3,37,3,36,3,35,3,34,3,33,3,32,3,31,3,30,3,29,3,28,3,27,3,26,3,25,3,24,3,23,3,22,3,21,3,20,3,19,3,18,3,17,3,16,3,15,3,14,3,13,3,12,3,11,3,10,3,9,3,8,3,7,3,6,3,5,2,4,2,3,3,2,3,1,4,0,43,0]
      type: 'poly'
  partyMarker:
    image: new google.maps.MarkerImage(
      '/images/app/party-map-icon.png',
      new google.maps.Size(48,48),
      new google.maps.Point(0,0),
      new google.maps.Point(24,48))
    shadow: new google.maps.MarkerImage(
      '/images/app/party-map-icon-shadow.png',
      new google.maps.Size(76,48),
      new google.maps.Point(0,0),
      new google.maps.Point(24,48))
    selected: new google.maps.MarkerImage(
      '/images/app/party-map-icon-selected.png',
      new google.maps.Size(48,48),
      new google.maps.Point(0,0),
      new google.maps.Point(24,48))
    shape:
      coord: [43,0,44,1,44,2,44,3,44,4,44,5,44,6,44,7,44,8,44,9,44,10,44,11,44,12,44,13,44,14,44,15,44,16,44,17,44,18,44,19,44,20,44,21,44,22,44,23,44,24,44,25,44,26,44,27,44,28,44,29,44,30,44,31,44,32,44,33,44,34,44,35,44,36,44,37,44,38,44,39,44,40,43,41,29,42,28,43,27,44,26,45,25,46,24,47,23,47,22,46,21,45,20,44,19,43,18,42,4,41,3,40,3,39,3,38,3,37,3,36,3,35,3,34,3,33,3,32,3,31,3,30,3,29,3,28,3,27,3,26,3,25,3,24,3,23,3,22,3,21,3,20,3,19,3,18,3,17,3,16,3,15,3,14,3,13,3,12,3,11,3,10,3,9,3,8,3,7,3,6,3,5,2,4,2,3,3,2,3,1,4,0,43,0]
      type: 'poly'
  mapLoaded: false
  # setupMap options:
    # targetElement -> Selector string for the map target
    # mapCenter -> Object with lat and lon properties for setting the maps center position
    # markers -> Array of objects with markers to be placed on the map
    # markerClickCallback -> Callback function to be invoked when marker is clicked
      # Parameters: e -> event Object
  setupMap: (options) ->
    NH_MAPTYPE_ID = 'noitehoje'

    map = new google.maps.Map(
      $(options.targetElement)[0],
      zoom: 14
      center: options.mapCenter
      mapTypeControlOptions:
       mapTypeIds: [google.maps.MapTypeId.ROADMAP, NH_MAPTYPE_ID]
    )

    styledMapOptions =
      name: 'Mapa Noturno'

    nhMapType = new google.maps.StyledMapType(gmaps_styles, styledMapOptions)

    map.mapTypes.set NH_MAPTYPE_ID, nhMapType
    map.setMapTypeId NH_MAPTYPE_ID

    NOITEHOJE.webApp.googleMaps.createMarkers map, options.markers, options.markerClickCallback

  displayEventsMap: () ->
    $('#listings, .view-ordering, .view-scope').hide() # hide list controls
    $('#map_wrapper, #map_loader').show()
    NOITEHOJE.webApp.location.updateLocationWithScope 'map' # update url
    NOITEHOJE.webApp.eventDetails.closeDetailsPanel() # if open, close the event details panel
    unless NOITEHOJE.webApp.googleMaps.mapLoaded
      $.getJSON("#{location.protocol}//#{location.host}/getlocations")
        .success((e) -> NOITEHOJE.webApp.googleMaps.setupMap
          markers: e
          mapCenter: NOITEHOJE.webApp.googleMaps.CITIES_LOCATIONS["porto-alegre"]
          targetElement: '#map_canvas'
          markerClickCallback: (evt) ->
            NOITEHOJE.webApp.eventDetails
              .getEventDetails(evt.id)
              .success (data) ->
                NOITEHOJE.webApp.location.updatePageTitle data
                NOITEHOJE.webApp.eventDetails.openEventDetailsPanel data
                NOITEHOJE.webApp.location.updateLocationForEventDetails parseUri(data.permalink).relative
        )
        .complete(() ->
          $('#map_loader').hide()
          NOITEHOJE.webApp.googleMaps.mapLoaded = true
        )

  unselectCurrentMarker: () ->
    currMarker = NOITEHOJE.webApp.googleMaps.selectedMarker
    currMarker.setIcon(currMarker.markerType.image) if currMarker
    NOITEHOJE.webApp.googleMaps.selectedMarker = null

  createMarkers: (map, markers, clickCallback) ->
    for event in markers
      ((e) ->
        # choose the marker type depending on the event type
        markerType = if e.type == 'show' then NOITEHOJE.webApp.googleMaps.showMarker else NOITEHOJE.webApp.googleMaps.partyMarker
        marker = new google.maps.Marker(
          position: new google.maps.LatLng(e.lat, e.lon)
          map: map
          icon: markerType.image
          shadow: markerType.shadow
          shape: markerType.shape
          title: e.title)
        marker.markerType = markerType

        google.maps.event.addListener marker, 'click', () ->
          NOITEHOJE.webApp.googleMaps.unselectCurrentMarker()
          marker.setIcon markerType.selected
          NOITEHOJE.webApp.googleMaps.selectedMarker = marker
          clickCallback(e) if clickCallback
      )(event)
)()
