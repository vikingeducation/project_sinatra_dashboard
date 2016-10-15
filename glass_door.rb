require 'httparty'
require 'pry-byebug'


class GlassDoor

	include HTTParty

	ID = ENV["GLASS_ID"]
	KEY = ENV["GLASS_KEY"]
	IP = "98.101.80.154"


	def initialize
binding.pry
		@url = 	"http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=#{ID}&t.k=#{KEY}&action=employers&q=pharmaceuticals&userip=#{IP}&useragent=Chrome/%2F4.0"


	end


	def get_forecast

		@output = self.class.get( @url )
		binding.pry

	end


	def print_daily

		 puts "Daily average for #{ @city_render }"
		 day = 0

		 @output["list"].each { |s| puts "Day #{day += 1} : #{s["temp"]["day"]}" }

	end


	def print_highs

		puts "Daily highs for #{ @city_render }"
		day = 0

		@output["list"].each { |s| puts "Day #{day += 1} : #{s["temp"]["max"]}" }

	end


	def get_description

		puts "Daily description for Chicago, IL"
		day = 0

		 @output["list"].each do |s|

		 	s["weather"].each do | w |

		 		puts "Day #{day += 1} : #{w["description"]}"

		 	end
		 end
	end

end

#weather_forecast = WeatherForecast.new("Chicago, IL", 8 )
#weather_forecast.get_forecast
#puts ""
#weather_forecast.print_daily
#puts ""
#weather_forecast.print_highs
#puts ""
#weather_forecast.get_description
