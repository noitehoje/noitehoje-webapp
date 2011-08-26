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
      open(URI.encode("#{base_url}api/v1/#{App.config.api_keys.first}/getevent/#{params[:id]}")).read
    end

    get "/event/:id/:slug" do
      no_mobile!
      get_event params[:id]
      slim :root
    end

    get "/show" do
      no_mobile!
      set_up_events nil, "show"
      slim :root
    end

    get "/party" do
      no_mobile!
      set_up_events nil, "party"
      slim :root
    end

    get "/map" do
      no_mobile!
      set_up_events nil, nil
      @map_view = true
      slim :root
    end

    get "/about" do
      no_mobile!
      set_up_events nil, nil
      @open_about = true
      slim :root
    end

    get "/" do
      no_mobile!
      set_up_events nil, nil
      slim :root
    end

    def set_up_events city, type
      json = get_json "#{base_url}api/v1/#{App.config.api_keys.first}/getallevents"
      @events = json["events"]
      @cities = App.config.supported_cities.sort_by {|c| c[:name] }
      @title = NoiteHoje::WebApp.get_title city, type
    end

    def get_event event_id
      json = get_json "#{base_url}api/v1/#{App.config.api_keys.first}/getallevents"
      @events = json["events"]

      json = get_json "#{base_url}api/v1/#{App.config.api_keys.first}/getevent/#{event_id}"
      @event = json

      @cities = App.config.supported_cities.sort_by {|c| c[:name] }
      @title = NoiteHoje::WebApp.get_title @event["venue"]["location"]["city"], @event["evt_type"]
    end

    def base_url
      ENV["RACK_ENV"] == "development" ? "http://localhost:3456/" : "http://api.noitehoje.com.br/"
    end

    def get_json url
      JSON.parse(open(URI.encode(url)).read)
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

  end
end
