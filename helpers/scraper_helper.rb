require '.\models\dice_scraper.rb'
require 'httparty'
require '.\models\company_profiler.rb'


module ScraperHelper

  def format_link(link)
    if link.include? "http"
      raw_link = link
      link.replace '<a href="' + raw_link + '">Link</a>'
    end
  end

  def combine_results
    results = CSV.read("results.csv")

  end

  def get_location(ip_address = "23.81.0.59")
    url = "http://freegeoip.net/json/" + ip_address
    response = HTTParty.get(url)
    location_hash = JSON.parse(response.body)
    session["location"] = location_hash["city"] + ", " + location_hash["region_code"]
    session["zip_code"] = location_hash["zip_code"]
  end
# fix this

  def get_jobs(search_term, location)
    j = JobScraper.new(search_term, location)
    # j.scrape
    add_gd
  end

  def add_gd
    new_output = []
    results = CSV.read("results.csv")
    results.each do |job|
      company = job[1]
      location = session["zip_code"]
      c = CompanyProfiler.new(company, location)
      ratings = c.get_data
      ratings.each do |rating|
        job << rating
      end
      new_output << job
    end
    CSV.open("combined_results.csv", "a") do |csv|
      binding.pry
      new_output.each do |job|
        csv << job
      end
    end
  end
end
