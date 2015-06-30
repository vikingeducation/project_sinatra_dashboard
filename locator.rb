require 'json'
require 'httparty'


class Locator

  include HTTParty

  base_uri "http://www.telize.com/"
  # API_KEY = ENV["TELIZE_API_KEY"]

  def initialize
  end


  def fetch_location
    parse( get_location( get_client_ip ) )
  end


  private


  def get_client_ip
    ENV["REMOTE_ADDR"] # try request.ip in app.rb
  end


  def get_location(ip)
    self.class.get("/geoip/#{ip}")
  end


  def parse(response)
    response = JSON.parse(response.body)
    # ERROR if response["country_code"] != "US"
    zip = response["postal_code"]
    city = response["city"]
    state = response["region"]
    coords = [ response["latitude"], response["longitude"] ]

    zip
  end

end