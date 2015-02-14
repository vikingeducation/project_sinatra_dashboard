require 'mechanize'
require 'nokogiri'
require 'pry'


class WeatherScraper
  def initialize (location)
    weatherman = Mechanize.new

    page = weatherman.get('')


  end

  def get_weather_data

  end
end