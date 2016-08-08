require 'pry'
require_relative "scraper_ui.rb"
require_relative "scraper.rb"
class JobScraper
  def get(key_word)
    jobs = ScraperUI.new
    jobs.search({q: key_word}, nil)
    scraper = Scraper.new(jobs)
    jobs = scraper.job_pages
  end
end

# p JobScraper.new.get("ruby")
