module Helper

	def new_job_search

		@job_scraper = Dice.new

		@job_scraper.search( 'ruby', 'Chicago, IL' )

		@job_scraper.pull_job_list

		@csv = @job_scraper.create_csv


	end


	def save_session

		session[ :job ] = @job_scraper.to_json

	end



end