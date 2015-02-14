require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'pry'
require_relative 'weather_day.rb'


class WeatherScraper
  attr_reader :forecast
  def initialize(location)
    @location = location
    @weatherman = Mechanize.new
    @page = get_page
    @calendar = get_calendar
    @next_ten_days = assemble_next_ten_days
    @forecast = get_forecast
  end

  private

  attr_reader :location, :weatherman, :page, :calendar, :next_ten_days

  def get_page
    wunderground_url = "http://www.wunderground.com/cgi-bin/findweather/getForecast?query=" + location.to_s
    weatherman.get(wunderground_url)
  end

  def get_calendar
    calendar_link = page.link_with text: " View Calendar Forecast"
    calendar_url = calendar_link.href
    weatherman.get(calendar_url)
  end

  def assemble_next_ten_days
    today = calendar.search("td.day.todayBorder")
    next_nine_days = calendar.search("td.day.forecast")
    today + next_nine_days
  end

  def get_forecast
    (0..9).each_with_object([]) do |day, forecast|
      forecast << WeatherDay.new( get_date(day),
                                  get_high_temp(day),
                                  get_low_temp(day),
                                  get_classification(day) )
    end
  end

  def get_date(day)
    next_ten_days[day].search(".dateText").text.strip
  end

  def get_high_temp(day)
    next_ten_days[day].search("span.high")[0].text.strip
  end

  def get_low_temp(day)
    next_ten_days[day].search("span.low")[0].text.strip
  end

  def get_classification(day)
    next_ten_days[day].search(".show-for-large-up").text.strip
  end
end