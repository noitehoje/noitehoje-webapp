NOITEHOJE.webApp.eventDetails = (() ->
  WEEKDAYS: ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"]
  MONTHS: ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
  formatDateTime: (event) ->
    d = new Date Date.parse(event.start_date)
    date_time_text = "#{this.WEEKDAYS[d.getDay()]}, #{d.getDate()} de #{this.MONTHS[d.getMonth()]}"
    date_time_text += ", #{event.start_time}" if event.start_time
    date_time_text
  getTwitterIframeSrc: (e) ->
    tweet_text = encodeURIComponent "#{document.title}"
    tweet_url = encodeURIComponent e.short_url
    "http://platform0.twitter.com/widgets/tweet_button.html?_=1306124701842&count=horizontal&lang=en&text=#{tweet_text}&url=#{tweet_url}&via=noitehoje"
  refreshFacebookLikeButton: (e) ->
    fb_li = $("#details li.facebook")
    fb_li.empty().append("<fb:like href='#{e.short_url}' colorscheme='dark' send='false' width='270' show_faces='false' font='arial'></fb:like>")
    FB.XFBML.parse(fb_li.get(0))
  isEventDetailsOpen: () ->
    $('#details').attr("data-opened") == "true"

  openEventDetailsPanel: (p, immediate) ->
    description_tab = $(".show-event-description")
    if p.description then description_tab.show() else description_tab.hide()

    if immediate
      details = $('#details').show().css("right", 0).attr 'data-opened', true
    else
      details = $('#details').show().stop().animate({ right: 0 , 300 }).attr 'data-opened', true

    details.find('h2 .event-title').text p.title
    details.find('span.venue-name').text(p.venue.name or '')
    details.find('p.address').text(p.venue.location.street or '')
    details.find('p.description').html(p.description or '')
    details.find('p.phone').text(p.venue.phone or '')
    if p.venue.url
      evt_url = if p.venue.url.indexOf('http://') < 0 then 'http://' + p.venue.url else p.venue.url
    details.find('p.site a').attr('href', evt_url or '').text(evt_url or '')
    details.find('h3 .date').text(this.formatDateTime p)
    details.find('.twitter-share-button').attr "src", this.getTwitterIframeSrc(p)
    this.refreshFacebookLikeButton(p)
    details.find('img.photo').attr('src', p.flyer or p.venue.image or '/images/app/party-placeholder.png')
    details.find('a.photo-link')
      .attr('href', p.flyer or p.venue.image or '/images/app/party-placeholder.png')
      .data('title', p.title)
    details.find('.source-data').text p.source

    # make sure we start displaying the map
    $('.show-event-map').click()

    # Set up event details map marker, center, etc.
    eventData =
      title: p.title
      lat: p.venue.location.geo_lat
      lon: p.venue.location.geo_lon
      type: p.evt_type
    mapOptions =
      markers: [ eventData ]
      mapCenter: new google.maps.LatLng eventData.lat, eventData.lon
      targetElement: '.details-map'

    NOITEHOJE.webApp.googleMaps.setupMap mapOptions

    details.find('span.event-type-icon').removeClass('party').removeClass('show').addClass p.evt_type

  closeDetailsPanel: () ->
    $('#listings li').removeClass 'current'
    $('#details').stop().animate({ right: -600 , 200 }).attr 'data-opened', false
    setTimeout "$('#details').hide()", 200

  getEventDetails: (eventId) ->
    $.getJSON "#{location.protocol}//#{location.host}/geteventjson/#{eventId}"
)()

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

  $('#details').attr 'data-opened', false

  # TABS
  $('.tabs-control li').click (e) ->
    e.preventDefault()
    $('.tabs-control li').removeClass 'current'
    current_tab = $(this).attr 'class'
    $(this).addClass 'current'

    $('#details').find('p.description, .details-map, .details-ppl-checkd-in, .details-comments').hide()
    if current_tab == 'show-event-map'
      $('#details .details-map').show()
    else if current_tab == "show-event-description"
      $('#details p.description').show()
    else if current_tab == "show-ppl-checkd-in"
      $('#details .details-ppl-checkd-in').show()
    else if current_tab == "show-comments"
      $('#details .details-comments').show()

  # Open details panel
  $('#listings li .vevent').live 'click', (e) ->
    e.preventDefault()
    $('#listings li').removeClass 'current'
    eventId = $(this).parent().addClass('current').end().attr 'id'
    link = $ this
    link.find('.event_loader').show()

    NOITEHOJE.webApp.eventDetails.getEventDetails(eventId)
      .success((data) =>
        NOITEHOJE.webApp.location.updatePageTitle data
        NOITEHOJE.webApp.eventDetails.openEventDetailsPanel data
        NOITEHOJE.webApp.location.updateLocationForEventDetails link.attr("href"))
      .complete(() => link.find('.event_loader').hide())

  # Close details panel
  $('#details a.close-panel, #listings .current').click (e) ->
    e.preventDefault()
    NOITEHOJE.webApp.eventDetails.closeDetailsPanel()
    NOITEHOJE.webApp.location.updateLocationForEventDetails()
    NOITEHOJE.webApp.googleMaps.unselectCurrentMarker()
    NOITEHOJE.webApp.location.updatePageTitle()
