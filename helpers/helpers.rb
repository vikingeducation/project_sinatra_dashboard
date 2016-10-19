

module Helper

IP = "67.235.56.2"

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
binding.pry
	end




	def get_location

				@location = HTTParty.get("https://www.freegeoip.net/json/#{IP}")

	end

end