require 'mechanize'
require 'date'

Weather = Struct.new(:date, :temp_high, :temp_low, :description)

class WeatherScraper

  def initialize
    @ten_day = []
  end

  def get_weather

    forecast = []

    scraper = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.history_added = Proc.new { sleep 0.5 } # just in case
    end

    scraper.get('http://www.wunderground.com/US/CA/Santa_Clara.html') do |page|

      calendar_page = page.links_with(href: /history\/airport/)[0].click

      calendar_page.search('.day').each do |day|

        current_day = Weather.new

        current_day.date = day.search('.dateText').text.strip
        current_day.description = day.search('.show-for-large-up').text.strip
        current_day.temp_high = day.search('.high')[0].text.strip
        current_day.temp_low = day.search('.low')[0].text.strip

        forecast << current_day

      end

      future_days = []

      forecast.each do |day|
        if day.date.to_i >= Date.today.day
          future_days << day
        end
      end

      future_days.first(10).map { |day| @ten_day << day }

    end
  end

  def table_render
    code = ''
    @ten_day.each do |day|
      code += '<tr>'
      code += "<td>#{day.date}</td>"
      code += "<td>#{day.temp_high}/#{day.temp_low}</td>"
      code += "<td>#{day.description}</td>"
      code += '<tr>'
    end
    return code
  end

end
