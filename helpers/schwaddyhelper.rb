# require 'rubygems'
# require 'bundler/setup'
# require 'mechanize'
# require 'pry'
# require 'nokogiri'
# require 'open-uri'
# require_relative 'weatherday'

module Schwaddyhelper
  WeatherDay = Struct.new(:high_temp, :low_temp, :forecast)
  SuchEbay = Struct.new(:title, :link, :price)

  def save_keyword(keyword)
    session[:keyword] = keyword
  end

  def save_maxprice(maxprice)
    session[:maxprice] = maxprice
  end

  def load_input
    session[:keyword]
    session[:maxprice]
  end

  class Weather
    attr_accessor :location, :weather_site, :searched_page, :forecast_ary, :low_temp_ary, :high_temp_ary, :ten_day_forecast
    def initialize(location)
      agent = Mechanize.new
      @location = location
      @weather_site = agent.get('http://www.wunderground.com')
      @weather_form = @weather_site.form_with(:id => "hp-search")
      @weather_form.query = location
      @button = @weather_site.form.button_with(:type => "submit")
      @searched_page = agent.submit(@weather_form, @button)
      @calendar_page = @searched_page.link_with(:text => /Calendar/).click
      #click is like an agent.get.... without it it's just the link
      high_temp
      low_temp
      forecast
      full_forecast
    end

    def high_temp
      @high_temp_ary = @calendar_page.search("span.high").map {|item| item.text.strip}
    end

    def low_temp
      @low_temp_ary = @calendar_page.search("span.low").map {|item| item.text.strip}
    end

    def forecast
      @forecast_ary = @calendar_page.search("td.show-for-large-up").map {|item| item.text.strip}
    end

    def full_forecast
      @ten_day_forecast = []
      counter = 0
      while counter < 10
        current_day = WeatherDay.new
        current_day.high_temp = @high_temp_ary[counter]
        current_day.low_temp = @low_temp_ary[counter]
        current_day.forecast = @forecast_ary[counter]
        @ten_day_forecast << current_day
        counter += 1
      end
    end
  end

  class InHouseEbay
    attr_reader :page, :search_page, :item_header, :item_link, :search_page, :price, :all_items, :top_price
    def initialize(keyword, top_price)
      agent = Mechanize.new
      @top_price = top_price
      agent.history_added = Proc.new {sleep 0.5}
      @page = agent.get('http://www.ebay.com/')
      my_form = page.form_with(:id => "gh-f")
      my_form._nkw = keyword
      @max_price = price
      @search_page = agent.submit(my_form)    
      item_header
      link_to_page
      very_price
      top_items
    end

    def item_header
      @item_header = @search_page.search("a.vip").map {|item| item.text.strip}

    end
    def very_price
      @price = @search_page.search("span.bold").map {|item| item.text.strip}
    end

    def link_to_page
      @item_link = @search_page.links_with(:class => "vip")
  .map {|item| item.href.strip}
    end

    def top_items
      @all_items = []
      counter = 0
      while counter < 20 && @item_header[counter] != nil
        if @price[counter][1..-1].to_f > @top_price.to_f
          counter += 1
          next
        else
          current_item = SuchEbay.new
          current_item.title = @item_header[counter]
          current_item.link = @item_link[counter]
          current_item.price = @price[counter]
          @all_items << current_item
          counter += 1
        end
      end
    end
  end


end