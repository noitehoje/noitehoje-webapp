#coding: utf-8
base_dir = "#{File.dirname(__FILE__)}/.."
env = ENV['RACK_ENV'] || "development"

require "#{base_dir}/api_helper.rb"
require "#{base_dir}/users.rb"

require "#{base_dir}/config/environment/#{env}"
require "#{base_dir}/config/initializers"

require "#{base_dir}/config/config"
require "#{base_dir}/http"

# Routes
require "#{base_dir}/routes/helpers"
require "#{base_dir}/routes/services"
require "#{base_dir}/routes/app"
require "#{base_dir}/routes/home"
require "#{base_dir}/routes/resources"
require "#{base_dir}/app"

# require crawler files
Dir["#{base_dir}/models/crawlers/*.rb"].each {|file| require file }
