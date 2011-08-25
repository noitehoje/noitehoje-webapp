#coding: utf-8

module NoiteHoje
  class WebApp < Sinatra::Base
    set :views, 'views'
    helpers Sinatra::NoiteHoje::Helpers

    use Rack::MobileDetect
    use HoptoadNotifier::Rack if ENV['RACK_ENV'] != 'development'

    get "/event/:id/:slug" do
      no_mobile!
      @event = Event.with_id_and_slug(params[:id], params[:slug]).first
      city = @event.venue.location.city.name.presence if @event.present?
      @events = Event.upcoming.at_city(city) if city.present?
      @title = NoiteHoje::WebApp.get_title city.presence, @event.evt_type.to_s, @event
      @cities = App.config.supported_cities.sort_by {|c| c.name }
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
      # facebook_connect!
      set_up_events nil, nil
      slim :root
    end

    def set_up_events city, type
      if ENV["RACK_ENV"] == "development"
        base_url = "http://localhost:3456/"
      else
        base_url = "http://api.noitehoje.com.br/"
      end

      url = "#{base_url}api/v1/#{App.config.api_keys.first}/getallevents"
      json = JSON.parse(open(URI.encode(url)).read)
      @events = json["events"]
      @cities = App.config.supported_cities.sort_by {|c| c[:name] }
      @title = NoiteHoje::WebApp.get_title city, type
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

        if city.present?
          the_city = City.by_parameter(city).first
          title << " em #{the_city}" if the_city
        end
      end

      title << " · Noite Hoje"
      title
    end

  end
end
