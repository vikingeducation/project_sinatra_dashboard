require_relative '../dice-scraper/lib/scraper'
require_relative '../dice-scraper/lib/dice_scraper_controller'
require_relative '../dice-scraper/lib/dice_jobs_page_parser'
require_relative '../dice-scraper/lib/job_writer'
require_relative '../dice-scraper/lib/dice_jobs_ui'

module DiceScraperHelper

  def convert_to_hashes(jobs)
    jobs.map { |job| job.to_hash }
  end

  def search(terms, location)
    DiceScraperController.new.search(terms, location)
  end

end
