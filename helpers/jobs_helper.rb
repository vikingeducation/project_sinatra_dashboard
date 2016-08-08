require_relative "../jobs_scraper.rb"

module JobHelper

  def get_jobs(search_text)
    JobScraper.new.get("ruby")
  end

end