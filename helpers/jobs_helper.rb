require_relative "../jobs_scraper.rb"
require_relative "../company_review.rb"
require 'mechanize'
module JobHelper
  def get_jobs(search_text, days)
    JobScraper.new.get(search_text, session[:city] ,days)
  end
end

module CompanyHelper
  def company_review(name)
    CompanyReview.new.get(name)
  end

  def get_reviews(jobs)
    hash = {}
    jobs.each do |job|
      hash[job["company"]] = CompanyReview.new.get(job["company"]) if hash[job["company"]].nil?
    end
    hash
  end
end

module GeoLocation
  def location(ip)
    uri = "http://freegeoip.net/json/#{ip}"
    agent = Mechanize.new
    agent.get(uri)
  end

end