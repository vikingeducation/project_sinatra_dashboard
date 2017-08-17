require '.\models\dice_scraper.rb'
require 'httparty'


module ScraperHelper
  def format_link(link)
    if link.include? "http"
      raw_link = link
      link.replace '<a href="' + raw_link + '">Link</a>'
    end
  end

  # def get_zip(ip_address = "23.81.0.59")
  #   url = "http://freegeoip.net/json/" + ip_address
  #   response = HTTParty.get(url)
  #   location_hash = JSON.parse(response.body)
  #   location_hash["zip_code"]
  # end

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
    j.scrape

  end
end
