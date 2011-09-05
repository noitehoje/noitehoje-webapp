$ () ->
  window.fbAsyncInit = () ->
    FB.init(
      appId: NOITEHOJE.webApp.facebookAppId
      status: true
      cookie: true
      xfbml: true)

  FB.Event.subscribe 'auth.login', (response) ->
    #if response.status == "connected"
      #console.log response.session

  if ($.browser.msie)
    $('body').addClass 'msie'

  # CALL THE RESIZE FUNCTION AND BINDS IT TO THE WINDOW RESIZE EVENT
  resize()
  $(window).bind 'resize', resize

  # VIEW-SCOPE
  $('.view-scope a').click (e) ->
    e.preventDefault()
    $('.view-scope a').removeClass 'selected'
    $(this).addClass('selected')
    view_scope = $(this).data('view-scope')
    friendlyType = 'Eventos'
    if view_scope == 'any'
      $('.vevent').show()
    else
      friendlyType = if view_scope == 'party' then 'Festas' else 'Shows'
      $(".vevent[data-event-type!='#{view_scope}']").hide()
      $(".vevent[data-event-type='#{view_scope}']").show()
    NOITEHOJE.webApp.location.listingEventTypes = friendlyType
    NOITEHOJE.webApp.location.updatePageTitle()
    NOITEHOJE.webApp.location.updateLocationWithScope view_scope

  # ABOUT
  $('#about').click (e) ->
    e.preventDefault()
    NOITEHOJE.webApp.location.updateLocationWithScope 'about'
    $('#modal-window').fadeIn 500

  # CLOSE ABOUT
  $('.close-modal').click (e) ->
    e.preventDefault()
    NOITEHOJE.webApp.location.updateLocationWithScope ''
    $('#modal-window').fadeOut 200

  # VIEW-TYPE
  $('.view-type a').click (e) ->
    e.preventDefault()
    current_view = $(this).data('view-type')
    $('.view-type a').removeClass 'current'
    $(this).addClass 'current'
    $('#listings').removeClass('small-list').removeClass('large-list').removeClass('map-view')
    if current_view == 'map-view'
      NOITEHOJE.webApp.googleMaps.displayEventsMap()
    else
      NOITEHOJE.webApp.location.updateLocationWithScope ''
      $('#listings').show().addClass current_view
      $('.view-dropdown, .view-scope').show()
      $('#map_wrapper').hide()

  #LOGIN WINDOW
  $('#user-login').click (e) ->
    e.preventDefault()
    $('.login-dropdown').show()

  $('.user-panel').click (e) ->
    e.preventDefault()
    $('.services-dropdown').show()

  $('body').click (e) ->
    $('.change-dropdown:visible').hide() if $(e.target).parents('.view-dropdown').length == 0
    $(".login-dropdown:visible").hide() if $(e.target).parents('.login').length == 0
    $(".services-dropdown:visible").hide() if $(e.target).parents('.user-panel').length == 0

# SETS THE HEIGHT FOR THE DETAILS PANEL
resize = () ->
  # CALCULATES THE HEIGHT AVAILABLE FOR THE DETAILS PANEL
  detailsHeight = $(window).height() - 88
  $('#details').height detailsHeight
