NOITEHOJE.webApp.search = (() ->
  filterList: (filter) ->
    events = this.allEvents
    events.show()
    return if filter == ''
    events.each () ->
      regex = new RegExp filter, 'gi'
      thisElem = $ this
      searchText = "#{thisElem.find('h2').text()} #{thisElem.find('h3').text()}"
      thisElem.hide() if searchText.match(regex) == null

  clearFilter: () ->
    # Restore the event list to the original contents
    $('.events li').hide()
    this.allEvents.show()
)()

$ () ->
  $('#search')
    .focus () ->
      if $(this).val() == ''
        $(this).animate({ width: 200 }, 500)
        NOITEHOJE.webApp.search.allEvents = $('.events li:visible')
    .blur () ->
      if $(this).val() == ''
        $(this).animate({ width: 100 }, 500)
        NOITEHOJE.webApp.search.clearFilter()
      else
        $('#search-loading').show()
    .bind 'search', () ->
      NOITEHOJE.webApp.search.clearFilter()
    .keyup (e) ->
      self = this
      if e.keyCode == 27
        $(self).val('').blur()
        return true
      clearTimeout typingTimer
      typingTimer = setTimeout () ->
        filter = $(self).val()
        NOITEHOJE.webApp.search.filterList filter
      , 500
