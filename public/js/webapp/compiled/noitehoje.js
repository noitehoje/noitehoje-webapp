(function() {
  var filterByCity, resize;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  window.NOITEHOJE = {
    webApp: {
      apiKey: 'crEjew8r',
      version: '1.0'
    }
  };
  NOITEHOJE.webApp.googleMaps = (function() {
    return {
      PORTO_ALEGRE: new google.maps.LatLng(-30.027704, -51.228735),
      showMarker: {
        image: new google.maps.MarkerImage('/images/webapp/show-map-icon.png', new google.maps.Size(48, 48), new google.maps.Point(0, 0), new google.maps.Point(24, 48)),
        shadow: new google.maps.MarkerImage('/images/webapp/show-map-icon-shadow.png', new google.maps.Size(76, 48), new google.maps.Point(0, 0), new google.maps.Point(24, 48)),
        selected: new google.maps.MarkerImage('/images/webapp/show-map-icon-selected.png', new google.maps.Size(48, 48), new google.maps.Point(0, 0), new google.maps.Point(24, 48)),
        shape: {
          coord: [43, 0, 44, 1, 44, 2, 44, 3, 44, 4, 44, 5, 44, 6, 44, 7, 44, 8, 44, 9, 44, 10, 44, 11, 44, 12, 44, 13, 44, 14, 44, 15, 44, 16, 44, 17, 44, 18, 44, 19, 44, 20, 44, 21, 44, 22, 44, 23, 44, 24, 44, 25, 44, 26, 44, 27, 44, 28, 44, 29, 44, 30, 44, 31, 44, 32, 44, 33, 44, 34, 44, 35, 44, 36, 44, 37, 44, 38, 44, 39, 44, 40, 43, 41, 29, 42, 28, 43, 27, 44, 26, 45, 25, 46, 24, 47, 23, 47, 22, 46, 21, 45, 20, 44, 19, 43, 18, 42, 4, 41, 3, 40, 3, 39, 3, 38, 3, 37, 3, 36, 3, 35, 3, 34, 3, 33, 3, 32, 3, 31, 3, 30, 3, 29, 3, 28, 3, 27, 3, 26, 3, 25, 3, 24, 3, 23, 3, 22, 3, 21, 3, 20, 3, 19, 3, 18, 3, 17, 3, 16, 3, 15, 3, 14, 3, 13, 3, 12, 3, 11, 3, 10, 3, 9, 3, 8, 3, 7, 3, 6, 3, 5, 2, 4, 2, 3, 3, 2, 3, 1, 4, 0, 43, 0],
          type: 'poly'
        }
      },
      partyMarker: {
        image: new google.maps.MarkerImage('/images/webapp/party-map-icon.png', new google.maps.Size(48, 48), new google.maps.Point(0, 0), new google.maps.Point(24, 48)),
        shadow: new google.maps.MarkerImage('/images/webapp/party-map-icon-shadow.png', new google.maps.Size(76, 48), new google.maps.Point(0, 0), new google.maps.Point(24, 48)),
        selected: new google.maps.MarkerImage('/images/webapp/party-map-icon-selected.png', new google.maps.Size(48, 48), new google.maps.Point(0, 0), new google.maps.Point(24, 48)),
        shape: {
          coord: [43, 0, 44, 1, 44, 2, 44, 3, 44, 4, 44, 5, 44, 6, 44, 7, 44, 8, 44, 9, 44, 10, 44, 11, 44, 12, 44, 13, 44, 14, 44, 15, 44, 16, 44, 17, 44, 18, 44, 19, 44, 20, 44, 21, 44, 22, 44, 23, 44, 24, 44, 25, 44, 26, 44, 27, 44, 28, 44, 29, 44, 30, 44, 31, 44, 32, 44, 33, 44, 34, 44, 35, 44, 36, 44, 37, 44, 38, 44, 39, 44, 40, 43, 41, 29, 42, 28, 43, 27, 44, 26, 45, 25, 46, 24, 47, 23, 47, 22, 46, 21, 45, 20, 44, 19, 43, 18, 42, 4, 41, 3, 40, 3, 39, 3, 38, 3, 37, 3, 36, 3, 35, 3, 34, 3, 33, 3, 32, 3, 31, 3, 30, 3, 29, 3, 28, 3, 27, 3, 26, 3, 25, 3, 24, 3, 23, 3, 22, 3, 21, 3, 20, 3, 19, 3, 18, 3, 17, 3, 16, 3, 15, 3, 14, 3, 13, 3, 12, 3, 11, 3, 10, 3, 9, 3, 8, 3, 7, 3, 6, 3, 5, 2, 4, 2, 3, 3, 2, 3, 1, 4, 0, 43, 0],
          type: 'poly'
        }
      },
      mapLoaded: false,
      setupMap: function(options) {
        var NH_MAPTYPE_ID, map, nhMapType, styledMapOptions;
        NH_MAPTYPE_ID = 'noitehoje';
        map = new google.maps.Map($(options.targetElement)[0], {
          zoom: 14,
          center: options.mapCenter,
          mapTypeControlOptions: {
            mapTypeIds: [google.maps.MapTypeId.ROADMAP, NH_MAPTYPE_ID]
          }
        });
        styledMapOptions = {
          name: 'Mapa Noturno'
        };
        nhMapType = new google.maps.StyledMapType(gmaps_styles, styledMapOptions);
        map.mapTypes.set(NH_MAPTYPE_ID, nhMapType);
        map.setMapTypeId(NH_MAPTYPE_ID);
        return NOITEHOJE.webApp.googleMaps.createMarkers(map, options.markers, options.markerClickCallback);
      },
      displayEventsMap: function() {
        $('#listings, .view-ordering, .view-scope').hide();
        $('#map_wrapper, #map_loader').show();
        NOITEHOJE.webApp.location.updateLocationWithScope('map');
        NOITEHOJE.webApp.eventDetails.closeDetailsPanel();
        if (!NOITEHOJE.webApp.googleMaps.mapLoaded) {
          return $.getJSON("" + location.protocol + "//" + location.host + "/api/v1/" + NOITEHOJE.webApp.apiKey + "/getlocations").success(function(e) {
            return NOITEHOJE.webApp.googleMaps.setupMap({
              markers: e,
              mapCenter: NOITEHOJE.webApp.googleMaps.PORTO_ALEGRE,
              targetElement: '#map_canvas',
              markerClickCallback: function(evt) {
                return NOITEHOJE.webApp.eventDetails.getEventDetails(evt.id).success(function(data) {
                  NOITEHOJE.webApp.location.updatePageTitle(data);
                  NOITEHOJE.webApp.eventDetails.openEventDetailsPanel(data);
                  return NOITEHOJE.webApp.location.updateLocationForEventDetails(parseUri(data.permalink).relative);
                });
              }
            });
          }).complete(function() {
            $('#map_loader').hide();
            return NOITEHOJE.webApp.googleMaps.mapLoaded = true;
          });
        }
      },
      unselectCurrentMarker: function() {
        var currMarker;
        currMarker = NOITEHOJE.webApp.googleMaps.selectedMarker;
        if (currMarker) currMarker.setIcon(currMarker.markerType.image);
        return NOITEHOJE.webApp.googleMaps.selectedMarker = null;
      },
      createMarkers: function(map, markers, clickCallback) {
        var event, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = markers.length; _i < _len; _i++) {
          event = markers[_i];
          _results.push((function(e) {
            var marker, markerType;
            markerType = e.type === 'show' ? NOITEHOJE.webApp.googleMaps.showMarker : NOITEHOJE.webApp.googleMaps.partyMarker;
            marker = new google.maps.Marker({
              position: new google.maps.LatLng(e.lat, e.lon),
              map: map,
              icon: markerType.image,
              shadow: markerType.shadow,
              shape: markerType.shape,
              title: e.title
            });
            marker.markerType = markerType;
            return google.maps.event.addListener(marker, 'click', function() {
              NOITEHOJE.webApp.googleMaps.unselectCurrentMarker();
              marker.setIcon(markerType.selected);
              NOITEHOJE.webApp.googleMaps.selectedMarker = marker;
              if (clickCallback) return clickCallback(e);
            });
          })(event));
        }
        return _results;
      }
    };
  })();
  NOITEHOJE.webApp.location = (function() {
    return {
      basePath: '/',
      citySlug: '',
      listingPath: null,
      listingEventTypes: 'Festas e Shows',
      listingTitle: 'Festas e Shows · Noite Hoje',
      titleSeparator: ' · ',
      updatePageTitle: function(e) {
        var newTitle, type;
        this.listingTitle = "" + this.listingEventTypes + this.titleSeparator + "Noite Hoje";
        if (e) {
          type = e.evt_type === 'party' ? 'Festa' : 'Show';
          newTitle = "" + type + " " + e.title + " em " + e.venue.location.city + this.titleSeparator + "Noite Hoje";
        } else {
          newTitle = this.listingTitle;
        }
        return document.title = newTitle;
      },
      updateLocationWithScope: function(type) {
        if (type === 'any') type = '';
        return History.pushState(null, null, this.basePath + type);
      },
      updateLocationForEventDetails: function(newPath) {
        var oldPath;
        if (newPath) {
          if (!this.listingPath) this.listingPath = location.pathname;
          return History.pushState(null, null, newPath);
        } else {
          oldPath = this.listingPath ? this.listingPath : this.basePath;
          History.pushState(null, null, oldPath);
          return this.listingPath = null;
        }
      }
    };
  })();
  History.Adapter.bind(window, 'statechange', function() {
    var State;
    return State = History.getState();
  });
  NOITEHOJE.webApp.search = (function() {
    return {
      filterList: function(filter) {
        var events;
        events = this.allEvents;
        events.show();
        if (filter === '') return;
        return events.each(function() {
          var regex, searchText, thisElem;
          regex = new RegExp(filter, 'gi');
          thisElem = $(this);
          searchText = "" + (thisElem.find('h2').text()) + " " + (thisElem.find('h3').text());
          if (searchText.match(regex) === null) return thisElem.hide();
        });
      },
      clearFilter: function() {
        $('.events li').hide();
        return this.allEvents.show();
      }
    };
  })();
  $(function() {
    return $('#search').focus(function() {
      if ($(this).val() === '') {
        $(this).animate({
          width: 200
        }, 500);
        return NOITEHOJE.webApp.search.allEvents = $('.events li:visible');
      }
    }).blur(function() {
      if ($(this).val() === '') {
        $(this).animate({
          width: 100
        }, 500);
        return NOITEHOJE.webApp.search.clearFilter();
      } else {
        return $('#search-loading').show();
      }
    }).bind('search', function() {
      return NOITEHOJE.webApp.search.clearFilter();
    }).keyup(function(e) {
      var self, typingTimer;
      self = this;
      if (e.keyCode === 27) {
        $(self).val('').blur();
        return true;
      }
      clearTimeout(typingTimer);
      return typingTimer = setTimeout(function() {
        var filter;
        filter = $(self).val();
        return NOITEHOJE.webApp.search.filterList(filter);
      }, 500);
    });
  });
  NOITEHOJE.webApp.ordering = (function() {
    return {
      sortAlpha: function(a, b) {
        if ($(a).find('h3').first().text() > $(b).find('h3').first().text()) {
          return 1;
        } else {
          return -1;
        }
      }
    };
  })();
  $(function() {
    NOITEHOJE.webApp.ordering.dateOrderedList = $('.events li');
    NOITEHOJE.webApp.ordering.nameOrderedList = $('.events li').sort(NOITEHOJE.webApp.ordering.sortAlpha);
    $('.view-dropdown').click(function() {
      return $(this).find('ul').show();
    });
    $('.change-dropdown a').click(function() {
      var dropdown, selected_option;
      selected_option = $(this).text();
      dropdown = $(this).parents('.view-dropdown');
      dropdown.find('.selected-item').text(selected_option);
      dropdown.find('ul').hide();
      return false;
    });
    $('.dd-ordering a').click(function() {
      var selected_ordering_title;
      selected_ordering_title = $(this).text();
      $('.events li').remove();
      if (selected_ordering_title.indexOf('nome') > 0) {
        NOITEHOJE.webApp.ordering.nameOrderedList.appendTo('.events');
      } else if (selected_ordering_title.indexOf('data') > 0) {
        NOITEHOJE.webApp.ordering.dateOrderedList.appendTo('.events');
      }
      return false;
    });
    return $('.dd-city a').click(function() {
      var city, filter;
      city = $(this).attr('id');
      if (city === 'all') {
        filter = null;
      } else {
        filter = $(this).text();
      }
      return filterByCity(filter);
    });
  });
  filterByCity = function(city) {
    return $('.events li span.location').each(function() {
      var li;
      li = $(this).parents('li');
      if (city && ($(this).text().toUpperCase() !== city.toUpperCase())) {
        return li.hide();
      } else {
        return li.show();
      }
    });
  };
  NOITEHOJE.webApp.eventDetails = (function() {
    return {
      WEEKDAYS: ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"],
      MONTHS: ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"],
      formatDateTime: function(event) {
        var d, date_time_text;
        d = new Date(Date.parse(event.start_date));
        date_time_text = "" + this.WEEKDAYS[d.getDay()] + ", " + (d.getDate()) + " de " + this.MONTHS[d.getMonth()];
        if (event.start_time) date_time_text += ", " + event.start_time;
        return date_time_text;
      },
      getTwitterIframeSrc: function(e) {
        var tweet_text, tweet_url;
        tweet_text = encodeURIComponent("" + document.title);
        tweet_url = encodeURIComponent(e.short_url);
        return "http://platform0.twitter.com/widgets/tweet_button.html?_=1306124701842&count=horizontal&lang=en&text=" + tweet_text + "&url=" + tweet_url + "&via=noitehoje";
      },
      refreshFacebookLikeButton: function(e) {
        var fb_li;
        fb_li = $("#details li.facebook");
        fb_li.empty().append("<fb:like href='" + e.short_url + "' colorscheme='dark' send='false' width='270' show_faces='false' font='arial'></fb:like>");
        return FB.XFBML.parse(fb_li.get(0));
      },
      isEventDetailsOpen: function() {
        return $('#details').attr("data-opened") === "true";
      },
      openEventDetailsPanel: function(p, immediate) {
        var description_tab, details, eventData, evt_url, mapOptions;
        description_tab = $(".show-event-description");
        if (p.description) {
          description_tab.show();
        } else {
          description_tab.hide();
        }
        if (immediate) {
          details = $('#details').show().css("right", 0).attr('data-opened', true);
        } else {
          details = $('#details').show().stop().animate({
            right: 0,
            300: 300
          }).attr('data-opened', true);
        }
        details.find('h2 .event-title').text(p.title);
        details.find('span.venue-name').text(p.venue.name || '');
        details.find('p.address').text(p.venue.location.street || '');
        details.find('p.description').html(p.description || '');
        details.find('p.phone').text(p.venue.phone || '');
        if (p.venue.url) {
          evt_url = p.venue.url.indexOf('http://') < 0 ? 'http://' + p.venue.url : p.venue.url;
        }
        details.find('p.site a').attr('href', evt_url || '').text(evt_url || '');
        details.find('h3 .date').text(this.formatDateTime(p));
        details.find('.twitter-share-button').attr("src", this.getTwitterIframeSrc(p));
        this.refreshFacebookLikeButton(p);
        details.find('img.photo').attr('src', p.flyer || p.venue.image || '/images/webapp/party-placeholder.png');
        details.find('a.photo-link').attr('href', p.flyer || p.venue.image || '/images/webapp/party-placeholder.png').data('title', p.title);
        details.find('.source-data').text(p.source);
        $('.show-event-map').click();
        eventData = {
          title: p.title,
          lat: p.venue.location.geo_lat,
          lon: p.venue.location.geo_lon,
          type: p.evt_type
        };
        mapOptions = {
          markers: [eventData],
          mapCenter: new google.maps.LatLng(eventData.lat, eventData.lon),
          targetElement: '.details-map'
        };
        NOITEHOJE.webApp.googleMaps.setupMap(mapOptions);
        return details.find('span.event-type-icon').removeClass('party').removeClass('show').addClass(p.evt_type);
      },
      closeDetailsPanel: function() {
        $('#listings li').removeClass('current');
        $('#details').stop().animate({
          right: -600,
          200: 200
        }).attr('data-opened', false);
        return setTimeout("$('#details').hide()", 200);
      },
      getEventDetails: function(eventId) {
        return $.getJSON("" + location.protocol + "//" + location.host + "/geteventjson/" + eventId);
      }
    };
  })();
  $(function() {
    $("a[rel^='prettyPhoto']").prettyPhoto({
      theme: 'dark_rounded',
      social_tools: false,
      opacity: 0.5,
      markup: "        <div class='pp_pic_holder'>          <div class='pp_top'>            <div class='pp_left'></div>            <div class='pp_middle'></div>            <div class='pp_right'></div>          </div>          <a class='pp_close' href='#'>× fechar</a>          <div class='pp_content_container'>            <div class='pp_left'>              <div class='pp_right'>                <div class='pp_content'>                  <div class='pp_loaderIcon'></div>                  <div class='pp_fade'>                    <a href='#' class='pp_expand' title='Expand the image'>Expand</a>                    <div class='pp_hoverContainer'>                      <a class='pp_next' href='#'>next</a>                      <a class='pp_previous' href='#'>previous</a>                    </div>                    <div id='pp_full_res'></div>                    <div class='pp_details'>                      <div class='ppt'>&nbsp;</div>                      <div class='pp_nav'>                        <a href='#' class='pp_arrow_previous'>Previous</a>                        <p class='currentTextHolder'>0/0</p>                        <a href='#' class='pp_arrow_next'>Next</a>                      </div>                      <p class='pp_description'></p>                    </div>                  </div>                </div>              </div>            </div>          </div>          <div class='pp_bottom'>            <div class='pp_left'></div>            <div class='pp_middle'></div>            <div class='pp_right'></div>          </div>        </div>        <div class='pp_overlay'></div>"
    });
    $("a.photo-link").click(function() {
      var elem, img_src;
      elem = $(this);
      img_src = elem.find('img').attr('src');
      if (img_src === '/images/webapp/party-placeholder.png') return false;
      return $.prettyPhoto.open(img_src, elem.data('title'), '');
    });
    $('#details').attr('data-opened', false);
    $('.tabs-control li').click(function(e) {
      var current_tab;
      e.preventDefault();
      $('.tabs-control li').removeClass('current');
      current_tab = $(this).attr('class');
      $(this).addClass('current');
      if (current_tab === 'show-event-map') {
        $('#details .details-map').show();
        return $('#details p.description').hide();
      } else {
        $('#details .details-map').hide();
        return $('#details p.description').show();
      }
    });
    $('#listings li .vevent').live('click', function(e) {
      var eventId, link;
      e.preventDefault();
      $('#listings li').removeClass('current');
      eventId = $(this).parent().addClass('current').end().attr('id');
      link = $(this);
      link.find('.event_loader').show();
      return NOITEHOJE.webApp.eventDetails.getEventDetails(eventId).success(__bind(function(data) {
        NOITEHOJE.webApp.location.updatePageTitle(data);
        NOITEHOJE.webApp.eventDetails.openEventDetailsPanel(data);
        return NOITEHOJE.webApp.location.updateLocationForEventDetails(link.attr("href"));
      }, this)).complete(__bind(function() {
        return link.find('.event_loader').hide();
      }, this));
    });
    return $('#details a.close-panel, #listings .current').click(function(e) {
      e.preventDefault();
      NOITEHOJE.webApp.eventDetails.closeDetailsPanel();
      NOITEHOJE.webApp.location.updateLocationForEventDetails();
      NOITEHOJE.webApp.googleMaps.unselectCurrentMarker();
      return NOITEHOJE.webApp.location.updatePageTitle();
    });
  });
  $(function() {
    window.fbAsyncInit = function() {
      return FB.init({
        appId: NOITEHOJE.webApp.facebookAppId,
        status: true,
        cookie: true,
        xfbml: true
      });
    };
    FB.Event.subscribe('auth.login', function(response) {});
    if ($.browser.msie) $('body').addClass('msie');
    resize();
    $(window).bind('resize', resize);
    $('.view-scope a').click(function(e) {
      var friendlyType, view_scope;
      e.preventDefault();
      $('.view-scope a').removeClass('selected');
      $(this).addClass('selected');
      view_scope = $(this).data('view-scope');
      friendlyType = 'Eventos';
      if (view_scope === 'any') {
        $('.vevent').show();
      } else {
        friendlyType = view_scope === 'party' ? 'Festas' : 'Shows';
        $(".vevent[data-event-type!='" + view_scope + "']").hide();
        $(".vevent[data-event-type='" + view_scope + "']").show();
      }
      NOITEHOJE.webApp.location.listingEventTypes = friendlyType;
      NOITEHOJE.webApp.location.updatePageTitle();
      return NOITEHOJE.webApp.location.updateLocationWithScope(view_scope);
    });
    $('#about').click(function(e) {
      e.preventDefault();
      NOITEHOJE.webApp.location.updateLocationWithScope('about');
      return $('#modal-window').fadeIn(500);
    });
    $('.close-modal').click(function(e) {
      e.preventDefault();
      NOITEHOJE.webApp.location.updateLocationWithScope('');
      return $('#modal-window').fadeOut(200);
    });
    $('.view-type a').click(function(e) {
      var current_view;
      e.preventDefault();
      current_view = $(this).data('view-type');
      $('.view-type a').removeClass('current');
      $(this).addClass('current');
      $('#listings').removeClass('small-list').removeClass('large-list').removeClass('map-view');
      if (current_view === 'map-view') {
        return NOITEHOJE.webApp.googleMaps.displayEventsMap();
      } else {
        NOITEHOJE.webApp.location.updateLocationWithScope('');
        $('#listings').show().addClass(current_view);
        $('.view-dropdown, .view-scope').show();
        return $('#map_wrapper').hide();
      }
    });
    $('#user-login').click(function(e) {
      e.preventDefault();
      return $('.login-dropdown').show();
    });
    return $('body').click(function(e) {
      if ($(e.target).parents('.view-dropdown').length === 0) {
        $('.change-dropdown:visible').hide();
      }
      if ($(e.target).parents('.login').length === 0) {
        return $(".login-dropdown:visible").hide();
      }
    });
  });
  resize = function() {
    var detailsHeight;
    detailsHeight = $(window).height() - 88;
    return $('#details').height(detailsHeight);
  };
}).call(this);
