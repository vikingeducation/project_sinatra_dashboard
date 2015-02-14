require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'pry'


class WeatherScraper
  attr_reader :page, :calendar
  def initialize(location)
    weatherman = Mechanize.new
    wunderground_url = "http://www.wunderground.com/cgi-bin/findweather/getForecast?query=" + location.to_s
    @page = weatherman.get(wunderground_url)
    calendar_link = page.link_with text: " View Calendar Forecast"
    calendar_url = calendar_link.href
    @calendar = weatherman.get(calendar_url)
  end

  def get_weather_data

  end
end