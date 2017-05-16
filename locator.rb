require 'mechanize'
require 'json'


ADDRESS = "http://www.freegeoip.net/json/?q=127.0.0.1"

class Locator

	def initialize
		@agent = Mechanize.new
		@agent.history_added = Proc.new { sleep 0.5}

	end

	def get_location
			@agent.get(ADDRESS) do |page|
			data = JSON.parse(page.body)
			parsed_results = parse_json(data)

			return parsed_results[1]
		end
	end

	def parse_json(data)
		ip = data["ip"]
		city = data["city"]
		state = data["region_code"]
		latitude = data["latitude"]
		longitude = data["longitude"]		

	  return parsed_json_location = [ip,city,state,latitude, longitude]
	end
end

#find = Locator.new
#find.get_location