# coding: utf-8
dirname = File.dirname(__FILE__)

module NoiteHoje
  class App < Sinatra::Base
    helpers Sinatra::NoiteHoje::Helpers
    use Rack::Session::Cookie,
      :key          => '_noitehoje_session',        # name of cookie that stores the data
      :domain       => nil,                         # you can share between subdomains here: '.communityguides.eu'
      :expire_after => 1.month,                     # expire cookie
      :secure       => false,                       # force https if true
      :httponly     => true,                        # a measure against XSS attacks, prevent client side scripts from accessing the cookie
      :secret      => COOKIE_SECRET

    use OmniAuth::Strategies::Facebook, FACEBOOK_APP_ID, FACEBOOK_APP_SECRET
    use OmniAuth::Strategies::Twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
    use OmniAuth::Strategies::Foursquare, FOURSQUARE_CLIENT_ID, FOURSQUARE_CLIENT_SECRET

    use NoiteHoje::Resources
    use NoiteHoje::WebApp
    use NoiteHoje::Services

    enable :sessions
    enable :raise_errors

    settings.default_encoding = 'utf-8'

    set :root, File.dirname(__FILE__)

    # Compass configuration
    configure do
      Compass.add_project_configuration(File.join(File.dirname(__FILE__), 'config', 'compass.config'))
    end

    def self.config
      @config ||= NoiteHoje::Config.new
    end
  end
end
