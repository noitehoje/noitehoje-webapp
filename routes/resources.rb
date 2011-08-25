#coding: utf-8

module NoiteHoje
  class Resources < Sinatra::Base
    set :views, 'views/../public/'
    use HoptoadNotifier::Rack if ENV['RACK_ENV'] != 'development'

    # CoffeeScript
    get '/coffee/:name.js' do
      coffee :"coffee/#{params[:name]}"
    end

    # Sass
    get '/scss/:name.css' do
      content_type 'text/css', :charset => 'utf-8'
      scss :"scss/#{params[:name]}", Compass.sass_engine_options
    end
  end
end
