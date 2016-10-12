require 'httparty'
require 'pry-byebug'

class GlassDoor

	include HTTParty

	base_uri "http://api.glassdoor.com/api/api.htm?v=1&format=xml"

	# example API call
	# http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120&t.k=fz6JLNDfgVs&action=employers&q=pharmaceuticals&userip=127.168.0.1&useragent=Mozilla/%2F4.0

		# require parameters
			# v - version is 1 except for jobs @ 1.1
			# format
			# t.p partner ID
			# t.k key
			# userip - IP address of end user
			# useragent - browser
			# action - API call - jobs, reviews, etc.
			# other - parameters for each API call

	def initialize

			@options = { query:

										{ "t.p"  => ENV["GLASSDOORID"],
											"t.k"     => ENV["GLASSDOOR_KEY"],
											"userip"   => "127.168.0.1",
											"useragent" => "Chrome",
											"action" => "employers",
											"other" => "pharmaceuticals"
										}

								 }

	end


	def open_door

		@output = self.class.get( "127.168.0.1", @options )
		binding.pry

	end



end

knob = GlassDoor.new

knob.open_door

