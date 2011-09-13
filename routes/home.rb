#coding: utf-8

module NoiteHoje
  class Home < Sinatra::Base
    set :views, 'views/home'
    helpers Sinatra::NoiteHoje::Helpers

    use Rack::MobileDetect
    use HoptoadNotifier::Rack if ENV['RACK_ENV'] != 'development'

    get '/home_wip' do
      slim :index
    end
  end
end
