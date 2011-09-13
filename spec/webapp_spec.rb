#coding: utf-8
require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../app'
require 'capybara'
require 'capybara/rspec'

Capybara.default_driver = :selenium

describe NoiteHoje::WebApp do
  def app
    @app ||= NoiteHoje::App
  end

  before { build_event }

  def build_event options = {}

    loc = Location.new(
      city: City.locate('Porto Alegre'),
      street: 'Somewhere street',
      country: 'Brazil')

    vne = Venue.new(
      name: 'Pepsi on Stage',
      url: 'www.pepsionstage.com.br',
      location: loc)

    evt = Event.new({
      title: 'Some event',
      date: DateTime.now.to_date + 2.days,
      evt_type: :show,
      description: 'Event description',
      venue: vne}.merge(options))

    evt.save
    vne.save
    loc.save

    evt
  end

  # integration tests
  # describe "the events list", :type: :request do
  #   it "should return correct event details" do
  #     build_event
  #     route = build_path :city: "Porto Alegre", :type: "show"
  #     session = Capybara::Session.new :selenium, NoiteHoje::App
  #     session.visit URI.encode(route)
  #     session.should have_content "Some event"
  #     #session.should have_selector("#details", :visible: true)
  #   end
  # end

  it('should return the correct title') { NoiteHoje::WebApp.get_title.should == "Festas e Shows · Noite Hoje" }
  it('should return the city name in the title') { NoiteHoje::WebApp.get_title("porto-alegre").should == "Festas e Shows em Porto Alegre · Noite Hoje" }
  it('should return the city name and show in the title') { NoiteHoje::WebApp.get_title("porto-alegre", "show").should == "Shows em Porto Alegre · Noite Hoje" }
  it('should return the city name and festa in the title') { NoiteHoje::WebApp.get_title("porto-alegre", "party").should == "Festas em Porto Alegre · Noite Hoje" }

  it('should return the city name, festa and event details in the title') do
    e = Event.first
    NoiteHoje::WebApp.get_title(
      "porto-alegre",
      "party",
      e).should == "Festa #{e.title} em Porto Alegre · Noite Hoje"
  end

  # def build_path filter
  #   route = "/"
  #   route << "/#{filter[:city]}" if filter[:city]
  #   route << "/#{filter[:type]}" if filter[:type]
  #   route << "/#{filter[:id]}" if filter[:id]
  #   route << "/#{filter[:slug]}" if filter[:slug]

  #   route
  # end
end
