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
    time = Time.new
    @ten_day_forecast = []
    day = time.day
    counter = 0
    while counter < 10
      current_day = WeatherDay.new
      current_day.high_temp = @high_temp_ary[(day*2)]
      current_day.low_temp = @low_temp_ary[(day*2)]
      current_day.forecast = @forecast_ary[day]
      @ten_day_forecast << current_day
      counter += 1
      day += 1
    end
  end
end