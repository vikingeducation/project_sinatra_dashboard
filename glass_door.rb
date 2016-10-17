require 'httparty'
require 'pry-byebug'


class GlassDoor

	include HTTParty

	ID = ENV["GLASS_ID"]
	KEY = ENV["GLASS_KEY"]
	IP = "209.37.67.195"


	def initialize
binding.pry
		@url = 	"http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=#{ID}&t.k=#{KEY}&action=employers&q=Lowes&city=Concord&state=NC&userip=#{IP}&useragent=Chrome/%2F4.0"


#"http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=#{ID}&t.k=#{KEY}&action=employers&q=pharmaceuticals&userip=#{IP}&useragent=Chrome/%2F4.0"

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



end
