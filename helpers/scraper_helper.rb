require '.\models\dice_scraper.rb'
require 'httparty'
require '.\models\company_profiler.rb'


module ScraperHelper
  # format_link
  def format_link(link)
    if link.include? "http"
      raw_link = link
      link.replace '<a href="' + raw_link + '">Link</a>'
    end
  end

  # combine_results
  def combine_results
    results = CSV.read("results.csv")
  end

  # get_location
  def get_location(ip_address = "50.22.219.2")
    url = "http://freegeoip.net/json/" + ip_address
    response = HTTParty.get(url)
    location_hash = JSON.parse(response.body)
    session["location"] = location_hash["city"] + ", " + location_hash["region_code"]
    session["zip_code"] = location_hash["zip_code"]
  end

  # get_jobs
  def get_jobs(search_term, location)
    j = JobScraper.new(search_term, location)
    # j.scrape
    add_gd(location)
  end

  # add_gd
  def add_gd(location)
    # integrates glassdoor ratings to the search results
    new_output = []
    results = CSV.read("results.csv")
    results.each do |job|
      company = job[1]
      c = CompanyProfiler.new(company, location)
      ratings = c.get_ratings
      if ratings
        ratings.each do |rating|
          job << rating
        end
      else
        6.times {job << "N/A"}
      end
      new_output << job
    end
    CSV.open("combined_results.csv", "a") do |csv|
      new_output.each do |job|
        csv << job
      end
    end
  end
end
