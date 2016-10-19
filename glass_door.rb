require 'httparty'
require 'pry-byebug'


class GlassDoor

	include HTTParty

	ID = ENV["GLASS_ID"]
	KEY = ENV["GLASS_KEY"]
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

		@company = get_reviews

		binding.pry

	end


	def get_reviews

		company = self.class.get( "", @options )

		company['response']['employers'][0]

=begin		{"id"=>2347,
		 "name"=>"CDW",
		 "website"=>"www.cdw.com",
		 "isEEP"=>true,
		 "exactMatch"=>true,
		 "industry"=>"Computer Hardware & Software",
		 "numberOfRatings"=>1250,
		 "squareLogo"=>"https://media.glassdoor.com/sqll/2347/cdw-squarelogo.png",
		 "overallRating"=>"3.9",
		 "ratingDescription"=>"Satisfied",
		 "cultureAndValuesRating"=>"4.2",
		 "seniorLeadershipRating"=>"3.8",
		 "compensationAndBenefitsRating"=>"3.4",
		 "careerOpportunitiesRating"=>"3.8",
		 "workLifeBalanceRating"=>"3.8",
		 "recommendToFriendRating"=>82,
		 "sectorId"=>10013,
		 "sectorName"=>"Information Technology",
		 "industryId"=>200060,
		 "industryName"=>"Computer Hardware & Software",
		 "featuredReview"=>
		  {"attributionURL"=>
		    "http://www.glassdoor.com/Reviews/Employee-Review-CDW-RVW12053166.htm",
=end


	end




end
