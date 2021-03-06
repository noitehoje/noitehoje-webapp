$ () ->
  $("a[rel^='prettyPhoto']").prettyPhoto(
    theme: 'dark_rounded'
    social_tools: false
    opacity: 0.5
    markup: "
        <div class='pp_pic_holder'>
          <div class='pp_top'>
            <div class='pp_left'></div>
            <div class='pp_middle'></div>
            <div class='pp_right'></div>
          </div>
          <a class='pp_close' href='#'>× fechar</a>
          <div class='pp_content_container'>
            <div class='pp_left'>
              <div class='pp_right'>
                <div class='pp_content'>
                  <div class='pp_loaderIcon'></div>
                  <div class='pp_fade'>
                    <a href='#' class='pp_expand' title='Expand the image'>Expand</a>
                    <div class='pp_hoverContainer'>
                      <a class='pp_next' href='#'>next</a>
                      <a class='pp_previous' href='#'>previous</a>
                    </div>
                    <div id='pp_full_res'></div>
                    <div class='pp_details'>
                      <div class='ppt'>&nbsp;</div>
                      <div class='pp_nav'>
                        <a href='#' class='pp_arrow_previous'>Previous</a>
                        <p class='currentTextHolder'>0/0</p>
                        <a href='#' class='pp_arrow_next'>Next</a>
                      </div>
                      <p class='pp_description'></p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class='pp_bottom'>
            <div class='pp_left'></div>
            <div class='pp_middle'></div>
            <div class='pp_right'></div>
          </div>
        </div>
        <div class='pp_overlay'></div>") # Initialize PrettyPhoto

  $("a.photo-link").click () ->
    elem = $ this
    img_src = elem.find('img').attr('src')
    return false if img_src == '/images/app/party-placeholder.png'
    $.prettyPhoto.open img_src, elem.data('title'), ''

  $(".details-map-wrapper .pp_close").click () ->
    $(this).parent().fadeOut()
    $("#details-map").empty().fadeOut()
    $(".details-map-overlay").fadeOut()
    return false

  $("a.map-link").click () ->
    $("#details-map, .details-map-wrapper, .details-map-overlay").fadeIn()

    elem = $ this
    latitude = elem.attr "data-lat"
    longitude = elem.attr "data-lon"

    setTimeout(() ->
     # Set up event details map marker, center, etc.
      eventData =
        title: "Event title"
        lat: latitude
        lon: longitude
        type: "party"
      mapOptions =
        markers: [ eventData ]
        mapCenter: new google.maps.LatLng eventData.lat, eventData.lon
        targetElement: '#details-map'

      NOITEHOJE.webApp.googleMaps.setupMap mapOptions
    , 500)

    return false
