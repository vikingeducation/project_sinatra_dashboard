require 'httparty'

class TelizeAPI
	END_POINT = 'http://www.telize.com/geoip/'

	attr_reader :ip,
				:city,
				:country_code,
				:country,
				:region_code,
				:region,
				:postal_code

	def locate(ip)
		@ip = ip
		response = HTTParty.get("#{END_POINT}#{@ip}")
		success = response.code == 200
		if success
			parsed_response = response.parsed_response
			@city = parsed_response['city']
			@country_code = parsed_response['country_code']
			@county = parsed_response['country']
			@region_code = parsed_response['region_code']
			@region = parsed_response['region']
			@postal_code = parsed_response['postal_code']
		end
		success
	end
end