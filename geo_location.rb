require 'mechanize'
require 'pry-byebug'
require 'json'

class GeoLocation


	attr_reader :location

	def initialize

		location = Mechanize.new { |agent|
		    agent.user_agent_alias = 'Mac Safari' }

		location.history_added = Proc.new { sleep 0.5 }

		url = 'https://www.freegeoip.net/json/'

		@location = location.get( url )

	end




end #./GeoLocation




