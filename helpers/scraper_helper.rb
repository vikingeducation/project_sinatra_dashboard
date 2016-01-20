require_relative '../lib/dice_scraper.rb'

module ScraperHelper

  def scraper_helper(time,search_term,zip)
    scraper = DiceScraper.new
    search_term.gsub(" ", "+")
    scraper.scrape_jobs(time,search_term,zip)
    scraper.jobs
  end

end
