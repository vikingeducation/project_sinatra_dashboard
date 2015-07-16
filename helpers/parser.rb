require_relative './scraper.rb'
require_relative './company_profiler.rb'
require 'nokogiri'
require 'mechanize'
require 'csv'
require 'Date'


module Parser

	class WriteJobs
		def initialize(description, location, userip)      	#initialize will never have a return value
			a = GetJobPage.new(description, location)
			job_search_results = a.scrape
			@glassdoor = CompanyProfiler.new(userip)
			@result = create_arr_of_job_entries(job_search_results)
			# create_csv_of_job_entries(job_search_results)
		end

		def result
			@result
		end

		def create_csv_of_job_entries(job_search_results)
			job_search_results.each_with_index do |job|
				CSV.open('csv_file.csv', 'a') do |csv|
					csv << [title(job), co_name(job), post_link(job),
							location(job), company_id(job), post_date(job)]	#job_id(job)
				end
			end
		end

		def create_arr_of_job_entries(job_search_results)
			jobs = []
			job_search_results.each_with_index do |job|
					jobs << [title(job), co_name(job), post_link(job),
									location(job), company_id(job), post_date(job), glassdoor_data(job)].flatten  #job_id(job)
			end
			jobs
		end

		def glassdoor_data(job)
			@glassdoor.data_to_send(co_name(job))
		end


		def title(job)
			job.css("a").first.text.strip if job.css("a").first != nil
		end

		def co_name(job)
			job.css("li a").first.children.text if job.css("li a").first != nil
		end

		def post_link(job)
			job.css("h3 a").first.attr('href') if job.css("h3 a").first != nil
		end

		def location(job)
			job.css("li")[1].text if job.css("li")[1] != nil
		end

		def post_date(job)
			posting_sched = job.css("li")[2].text if job.css("li")[2] != nil
			date = Date.today
			if posting_sched.include?("day")
				posting_day = posting_sched.match(/\d/)
				"#{date - posting_day[0].to_i}"
			elsif posting_sched.include?("week")
				posting_week = posting_sched.match(/\d/)
				"#{date - posting_week[0].to_i*7}"
			elsif posting_sched.include?("month")
				posting_month = posting_sched.match(/\d/)
				"#{date.prev_month(posting_month[0].to_i)}"
			else
				"#{date}"
			end
		end

		def company_id(job)
			link = job.css("h3 a").first.attr('href') if job.css("h3 a").first != nil
			com_id_string = link.match(/(?<=[0-9]\/)([a-zA-Z]||[0-9]).*(?=\/)/)
			com_id_string[0]
		end

		# def job_id(job)
		# 	link = job.css("h3 a").first.attr('href') if job.css("h3 a").first != nil
		# 	job_id_string = link.match(/(?<=\/)([A-Z]|[0-9])+([A-Z]|[0-9])+.*(?=\?)/)
		# 	exact = job_id_string[0].split("/") if (job_id_string[0] != nil) && (job_id_string[0].include?("/"))
		# 	exact != nil ? exact[1] : job_id_string[0]
		# end
	end
end