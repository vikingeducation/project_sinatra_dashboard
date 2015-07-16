require 'HTTParty'

module VisitorIP
	class GetIP
		def initialize(server_address)
			options = {query: {ip: server_address}}
			@location_data = HTTParty.get("http://www.telize.com/geoip/", options)
		end

		def user_location
			city = @location_data.parsed_response["city"]
			region = @location_data.parsed_response["region"]
			country = @location_data.parsed_response["country"]
			[city, region, country]
		end
	end
end