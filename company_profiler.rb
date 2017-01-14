require 'open-uri'
require 'json'


class CompanyProfiler

	def initialize(name)
		@name = name
	end

	def run
		buffer = open("http://api.glassdoor.com/api/api.htm?t.p=116710&t.k=bF6nGmiTcYE&format=json&v=1&action=employers&q=#{@name}").read
		response = JSON.parse(buffer)
		response['response']['employers'].each do |company|
			if company['exactMatch']
				return company['cultureAndValuesRating']
			end
		end
		return nil
	end

end

#cp = CompanyProfiler.new("eXcell")
#p cp.run