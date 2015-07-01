require 'json'
require 'httparty'


class Locator

  include HTTParty

  base_uri "http://www.telize.com/"

  def initialize(client_ip)
    @ip = client_ip
    check_client_ip
  end


  def fetch_location
    parse( get_location( @ip ) )
  end


  private


  def check_client_ip
    @ip = ENV["REMOTE_ADDR"] if @ip == "127.0.0.1"
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