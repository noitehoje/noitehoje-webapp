NOITEHOJE.webApp.ordering = (() ->
  sortAlpha : (a, b) ->
    if $(a).find('h3').first().text() > $(b).find('h3').first().text() then 1 else -1
)()

$ () ->
  NOITEHOJE.webApp.ordering.dateOrderedList = $('.events li')
  NOITEHOJE.webApp.ordering.nameOrderedList = $('.events li').sort NOITEHOJE.webApp.ordering.sortAlpha

  $('.view-dropdown').click () ->
    $(this).find('ul').show()

  $('.change-dropdown a').click () ->
    selected_option = $(this).text()
    dropdown = $(this).parents('.view-dropdown')
    dropdown.find('.selected-item').text(selected_option)
    dropdown.find('ul').hide()
    false

  $('.dd-ordering a').click () ->
    selected_ordering_title = $(this).text()
    $('.events li').remove()
    if selected_ordering_title.indexOf('nome') > 0
      NOITEHOJE.webApp.ordering.nameOrderedList.appendTo '.events'
    else if selected_ordering_title.indexOf('data') > 0
      NOITEHOJE.webApp.ordering.dateOrderedList.appendTo '.events'
    false

  $('.dd-city a').click () ->
    city = $(this).attr('id')
    if city == 'all'
      filter = null
    else
      filter = $(this).text()
    filterByCity filter

    if Modernizr.localstorage
      localStorage['selectedCity'] = filter

  # set the default city
  defaultCity = if Modernizr.localstorage && localStorage['selectedCity'] then localStorage['selectedCity'] else 'Porto Alegre'
  $(".view-dropdown .selected-item").text defaultCity
  filterByCity defaultCity

filterByCity = (city) ->
  $('.events li span.location').each () ->
    li = $(this).parents('li')
    if city && ($(this).text().toUpperCase() != city.toUpperCase()) then li.hide() else li.show()
