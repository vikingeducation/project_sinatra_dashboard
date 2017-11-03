require 'dotenv/load'
require 'httparty'
require 'pp'
require 'json'
require 'date'
require 'pry'

class FreeGeoAPI

  BASE_URI = 'http://freegeoip.net'
  FORMAT = 'json'

  def initialize(ip_address)
    @ip_address = ip_address
  end

  def send_request
    url = "#{BASE_URI}/#{FORMAT}/#{@ip_address}"
    response = HTTParty.get(url)
    parse_location(response)
  end

  private

  def parse_location(response)
    city = response.parsed_response['city']
    state = response.parsed_response['region_code']
    "#{city}, #{state}"
  end

end