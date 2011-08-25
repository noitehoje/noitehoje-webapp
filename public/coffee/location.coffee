NOITEHOJE.webApp.location = (() ->
  basePath: '/'
  citySlug: ''
  listingPath: null
  listingEventTypes: 'Festas e Shows'
  listingTitle: 'Festas e Shows · Noite Hoje'
  titleSeparator: ' · '

  updatePageTitle: (e) ->
    this.listingTitle = "#{this.listingEventTypes}#{this.titleSeparator}Noite Hoje"
    if e
      type = if e.evt_type == 'party' then 'Festa' else 'Show'
      newTitle = "#{type} #{e.title} em #{e.venue.location.city}#{this.titleSeparator}Noite Hoje"
    else
       newTitle = this.listingTitle

    document.title = newTitle

  # Updates the location url for the view scope filtering
  updateLocationWithScope: (type) ->
    type = '' if type == 'any'
    History.pushState null, null, this.basePath + type

  # Updates the location url for the event details panel
  updateLocationForEventDetails: (newPath) ->
    if newPath
      this.listingPath = location.pathname unless this.listingPath
      History.pushState null, null, newPath
    else
      oldPath = if this.listingPath then this.listingPath else this.basePath
      History.pushState null, null, oldPath
      this.listingPath = null
)()

History.Adapter.bind window, 'statechange', () ->
  State = History.getState()
  # History.log(State.data, State.title, State.url)
