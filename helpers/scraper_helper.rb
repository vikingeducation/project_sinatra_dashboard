require '../lib/dice_scraper.rb'

module ScraperHelper

  def scraper_helper(time,search_term)
    scraper = DiceScraper.new
    search_term.gsub(" ", "_")
    scraper.scrape_jobs(time,search_term)
    scraper.jobs
  end

end
