

module Helper

	def new_job_search( job, location )

		@job_scraper = Dice.new

		@job_scraper.search( job, location )

		@job_scraper.pull_job_list

		@csv = @job_scraper.create_csv

	end

	def save_ip

		session[ :ip ] = @ip

	end

	def save_session

		session[ :job ] = @job_scraper.to_json

	end


	def parse_job( job, location )

		if @job_scraper.nil?

			new_job_search( job, location )

		else

			@job_scraper = JSON.parse( session[ :job ])

		end


	end


	def get_location

		geo = GeoLocation.new

		location = JSON.parse( geo.loc_string )

		@city = location[ "city" ]
		@state = location[ "region_code" ]

		binding.pry

	end

end