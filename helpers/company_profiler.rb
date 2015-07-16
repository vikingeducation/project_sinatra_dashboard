class CompanyProfiler
	attr_reader :company_data
	def initialize(userip, useragent="Chrome")
		@userip = userip
		@useragent = useragent
		@company_data = nil
	end

	def data_to_send(company_name)
		source_company_data(company_name)
		company_details if check_if_correct?(company_name)
	end

	def source_company_data(company_name)
		options = {query: {v: "1", format: "json", "t.p" => ENV["ID"], "t.k" => ENV["KEY"], userip: @userip, useragent: @useragent, action: "employers", q: company_name}}
		@company_data = HTTParty.get("http://api.glassdoor.com/api/api.htm?", options)
	end

	def check_if_correct?(company_name)
		# binding.pry
		@company_data["response"]["employers"] &&
		@company_data["response"]["employers"][0] &&
		@company_data["response"]["employers"][0]["name"] &&
		@company_data["response"]["employers"][0]["name"] == company_name
	end

	def company_details
		@company_data["response"]["employers"][0]
		culture_and_leadership = @company_data["response"]["employers"][0]["cultureAndValuesRating"]
		compensation_and_benefits = @company_data["response"]["employers"][0]["compensationAndBenefitsRating"]
		featured_review = @company_data["response"]["employers"][0]["featuredReview"]["headline"]
		[culture_and_leadership, compensation_and_benefits, featured_review]
	end

end


