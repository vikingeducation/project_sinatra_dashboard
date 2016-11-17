require_relative '../dice-scraper/lib/scraper'
require_relative '../dice-scraper/lib/dice_scraper_controller'
require_relative '../dice-scraper/lib/dice_jobs_page_parser'
require_relative '../dice-scraper/lib/job_writer'
require_relative '../dice-scraper/lib/dice_jobs_ui'

module DiceScraperHelper

  def search(terms, location, profiler)
    puts "Starting job search ...."
    jobs = DiceScraperController.new.search(terms, location)

    return jobs if jobs.empty?
    return jobs unless profiler.is_a? CompanyProfiler

    add_profile(profiler, jobs)
  end

  def add_profile(profiler, jobs)
    puts "Adding Profiles..."

    jobs_per_comp = jobs.group_by { |job| job.company }

    jobs_per_comp.each do |company, jobs|
      profile = profiler.get_comp_info(jobs[0])

      jobs.each do |job|
        job.company_profile = profile
      end
    end

    jobs_per_comp.values.flatten
  end

end
