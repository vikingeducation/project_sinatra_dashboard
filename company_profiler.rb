require 'envyable'
require 'mechanize'
require 'json'
require 'pry'
require 'httparty'

Envyable.load('config/env.yml')

API_KEY = ENV["API_KEY"]
ID = ENV["ID"]
BASE_URI = "http://api.glassdoor.com/api/api.htm?"
Review = Struct.new(:name, :location,)

class CompanyProfiler

	include HTTParty

	def initialize(company="google")
		
		@address = BASE_URI
		@options = { :query => {
														q: "#{company}",
								 						v: "1",
								 						format: "json",
								 						useragent: "Chrome",
								 						action: "employers",
								 						"t.p".to_sym => ID,
								 						"t.k".to_sym => API_KEY
			}}
			
		@glass_review = self.class.get(BASE_URI, @options).parsed_response
	end

	def parsed_data
		results = []
		name =  @glass_review["response"]["employers"][0]["name"]
		location = @glass_review["response"]["employers"][0]["featuredReview"]["location"]
		job_review = Review.new(name, location)
		puts job_review.location
	end


end

company = CompanyProfiler.new("netflix")

company.parsed_data