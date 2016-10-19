

module Helper



	def save_ip
binding.pry
		session[ :ip ] = @location["ip"]

	end

	def save_session

		session[ :job ] = @job_scraper.to_json


	end


	def parse_job( job, location )
binding.pry
		if @job_scraper.nil?

			new_job_search( job, location )

		else

			@job_scraper = JSON.parse( session[ :job ] )

		end


	end


	def new_job_search( job, location )
binding.pry
		@job_scraper = Dice.new

		@job_scraper.search( job, location )

		@job_scraper.pull_job_list
binding.pry
		@csv = @job_scraper.create_csv

	end




	def get_location

		geo = GeoLocation.new

		@location = JSON.parse( geo.loc_string )


	end

end