#coding: utf-8

module NoiteHoje
  class WebApp < Sinatra::Base
    set :views, 'views'
    helpers Sinatra::NoiteHoje::Helpers

    use Rack::MobileDetect
    use HoptoadNotifier::Rack if ENV['RACK_ENV'] != 'development'

    get '/geteventjson/:id' do
      no_mobile!
      content_type 'application/json', :charset => 'utf-8'
      api_helper.event_details_json params[:id]
    end

    get '/getlocations' do
      no_mobile!
      content_type 'application/json', :charset => 'utf-8'
      api_helper.event_locations_json
    end

    get "/event/:id/:slug" do
      no_mobile!
      get_event params[:id]
      slim :'app/root', :layout => :'app/app'
    end

    get "/show" do
      no_mobile!
      set_up_events nil, "show"
      slim :'app/root', :layout => :'app/app'
    end

    get "/party" do
      no_mobile!
      set_up_events nil, "party"
      slim :'app/root', :layout => :'app/app'
    end

    get "/map" do
      no_mobile!
      set_up_events nil, nil
      @map_view = true
      slim :'app/root', :layout => :'app/app'
    end

    get "/about" do
      no_mobile!
      set_up_events nil, nil
      @open_about = true
      slim :'app/root', :layout => :'app/app'
    end

    get "/" do
      no_mobile!
      set_up_events nil, nil
      slim :'app/root', :layout => :'app/app'
    end

    def set_up_events city, type
      @events = api_helper.all_events
      @cities = App.config.supported_cities.sort_by {|c| c[:name] }
      @title = NoiteHoje::WebApp.get_title city, type
    end

    def get_event event_id
      @events = api_helper.all_events
      @event = api_helper.event_details event_id

      @cities = App.config.supported_cities.sort_by {|c| c[:name] }
      @title = NoiteHoje::WebApp.get_title @event["venue"]["location"]["city"], @event["evt_type"]
    end

    def self.get_title city = nil, type = nil, event = nil
      title = ""
      if event
        friendly_type = ((type == "party") ? "Festa" : "Show")
        title = "#{friendly_type} #{event.title} em #{event.venue.location.city}"
      else
        if type.present?
          title << ((type == "show") ? "Shows" : "Festas")
        else
          title << "Festas e Shows"
        end

        title << " em #{city}" if city.present?
      end

      title << " · Noite Hoje"
      title
    end

    # SITE
    get "/noitehoje" do
      slim :'home/index', :layout => :'home/layout'
    end
  end
end
