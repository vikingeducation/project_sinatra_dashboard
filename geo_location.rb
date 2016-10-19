require 'mechanize'
require 'open-uri'



class GeoLocation


	attr_reader :loc_string

	def initialize

		@loc_string = open( "https://www.freegeoip.net/json/" ).read

	end



end #./GeoLocation




