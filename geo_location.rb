require 'mechanize'
require 'pry-byebug'
require 'open-uri'
require 'json'


class GeoLocation


	attr_reader :location

	def initialize

		url = "https://www.freegeoip.net/json/"

		loc_string = open("https://www.freegeoip.net/json/").read

		binding.pry

	end



end #./GeoLocation




