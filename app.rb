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

    use OmniAuth::Builder do
      provider :facebook, FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, :scope => 'email,read_stream', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt', ca_path: "/etc/ssl/certs"} }
    end

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
