require 'pry'
require_relative "scraper_ui.rb"
require_relative "scraper.rb"
class JobScraper
  def get(key_word, location, days)
    jobs_ui = ScraperUI.new
    jobs_ui.search({q: key_word, l: location}, (Date.today - days))
    scraper = Scraper.new(jobs_ui)
    jobs = scraper.job_pages
  end
end

# p JobScraper.new.get("ruby")
