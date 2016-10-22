

module Helper



	def save_ip

		session[ :ip ] = @location["ip"]

	end

	def save_session

		session[ :job ] = @job_scraper.to_json


	end


	def parse_job( job, location )

		if @job_scraper.nil?

			new_job_search( job, location )

		else

			@job_scraper = JSON.parse( session[ :job ] )

		end

	end


	def new_job_search( job, location )

		@job_scraper = Dice.new

		@job_scraper.search( job, location )

		@job_scraper.pull_job_list

		@csv = @job_scraper.create_csv

	end



	def add_review

		return if !@csv

		@csv.each do | job |

			company = GlassDoor.new( job["company"], "Chicago", "IL" )

			review = company.get_reviews


			job["culture"] = review["cultureAndValuesRating"]
			job["leader"] = review["seniorLeadershipRating"]
			job["recommend"] = review["recommendToFriendRating"]

		end

	end


	def get_location

				@location = HTTParty.get("https://www.freegeoip.net/json/")

	end

end