require 'httparty'
require 'pry-byebug'


class GlassDoor

	attr_reader :company

	include HTTParty

	ID = ENV["GLASSID"]
	KEY = ENV["GLASSKEY"]
	IP = "67.235.56.2"


	base_uri 'http://api.glassdoor.com/api/api.htm?v=1&format=json'

	def initialize( company, city, state )

		@options = { query:

									{ "t.p"    		=> ID,
										"t.k"    		=> KEY,
										"action" 		=> "employers",
										"q"  		 		=> company,
										"city"   		=> city,
										"state"  		=> state,
										"userip"    => IP,
										"useragent" => "Chrome/%2F4.0"

									 }
							 }



	end

	def get_reviews

		company = self.class.get( "", @options )

		company['response']['employers'][0]

	end


end
