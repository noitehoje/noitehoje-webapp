#coding: utf-8

module NoiteHoje
  class WebApp < Sinatra::Base
    set :views, 'views/app'
    helpers Sinatra::NoiteHoje::Helpers

    register Sinatra::Flash

    use Rack::MobileDetect

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
      # #TODO route for slug v2.0
      # /city/:slug
      # SEE SLUG DOCUMENTATION AT NOITEHOJE-BACKEND
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

    get "/donate" do
      no_mobile!
      set_up_events nil, nil
      slim :root
    end

    get "/" do
      no_mobile!
      set_up_events nil, nil
      slim :root
    end

    # temporary route that redirects to the actual API url
    get "/api/*" do
      redirect "http://api.noitehoje.com.br#{request.env["REQUEST_URI"]}"
    end


    get '/mobile-details' do
      slim :'mobile-details', :layout => false
    end


    def set_up_events city, type
      @events = api_helper.all_events
      @cities = App.config.supported_cities.sort_by {|c| c[:name] }
      @title = NoiteHoje::WebApp.get_title city, type
    end

    def get_event event_id
      @events = api_helper.all_events
      @event = api_helper.event_details event_id

      if @event["error"]
        flash[:error] = "Festa ou show não encontrado."
        redirect "/"
      end

      @cities = App.config.supported_cities.sort_by {|c| c[:name] }
      @title = NoiteHoje::WebApp.get_title @event["venue"]["location"]["city"], @event["evt_type"], @event
    end

    def self.get_title city = nil, type = nil, event = nil
      title = ""
      if event
        friendly_type = ((type == "party") ? "Festa" : "Show")
        title = "#{friendly_type} #{event['title']} em #{city}"
      else
        if type.present?
          title << ((type == "show") ? "Shows" : "Festas")
        else
          title << "Festas e Shows"
        end

        title << " em #{city}" if city.present?
      end

      title
    end
  end
end
