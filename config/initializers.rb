#coding: utf-8
Time.zone = "America/Sao_Paulo"

Slim::Engine.set_default_options :pretty => true if ENV['RACK_ENV'] == 'development'

Date::MONTHNAMES = [nil, "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembero", "Dezembro"]
Date::DAYNAMES = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sabado"]

Twitter.configure do |config|
  config.consumer_key = TWITTER_CONSUMER_KEY
  config.consumer_secret = TWITTER_CONSUMER_SECRET
end