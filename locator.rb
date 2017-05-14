require 'mechanize'
require 'json'


ADDRESS = "http://www.freegeoip.net/json/github.com"

class Locator
	def initialize
		@agent = Mechanize.new
		@agent.history_added = Proc.new { sleep 0.5}

	end

	def get_location
		loc = @agent.get(ADDRESS) do |page|
			data = JSON.parse(page.body)
			puts data["city"]
		end
		
	end
end

find = Locator.new

find.get_location