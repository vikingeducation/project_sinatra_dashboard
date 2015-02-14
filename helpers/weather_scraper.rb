require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'pry'
require_relative 'weather_day.rb'


class WeatherScraper
  attr_reader :page, :calendar
  def initialize(location)
    wunderground_url = "http://www.wunderground.com/cgi-bin/findweather/getForecast?query=" + location.to_s
    weatherman = Mechanize.new
    @page = weatherman.get(wunderground_url)
    calendar_link = page.link_with text: " View Calendar Forecast"
    calendar_url = calendar_link.href
    @calendar = weatherman.get(calendar_url)
    binding.pry

    @forecast = []

    calendar.search("td.day.todayBorder") # This breaks tings
    calendar.search("td.day.forecast")[0].text # Also breaks
  end

  def get_weather_data

  end

  def scrape_forecast

  end
end