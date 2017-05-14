require 'envyable'
require 'mechanize'
require 'json'
require 'pry'

Envyable.load('config/env.yml')

API_KEY = ENV["API_KEY"]
ID = ENV["ID"]
BASE_URI = "http://api.glassdoor.com"

class CompanyProfiler
	def initialize(company_name = "Google")
		@agent = Mechanize.new
		@agent.history_added = Proc.new {sleep 0.5}
		@address = BASE_URI
		@options = { :query => {
								 						v: "1",
								 						format: "json",
								 						useragent: "Chrome",
								 						action: "employers",
								 						"t.p".to_sym => ID,
								 						"t.k".to_sym => API_KEY
			}}
			@options[:query][:q] = company_name
	end

	def get_company_info
		@agent.get(BASE_URI, @options) do |page|
			puts page.body
		end
	end
end

company = CompanyProfiler.new
company.get_company_info