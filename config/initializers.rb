#coding: utf-8
Time.zone = "America/Sao_Paulo"

Slim::Engine.set_default_options :pretty => true if ENV['RACK_ENV'] == 'development'

Date::MONTHNAMES = [nil, "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembero", "Dezembro"]
Date::DAYNAMES = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sabado"]