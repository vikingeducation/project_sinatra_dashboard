# ./models/GeoLocationHelper
require 'httparty'

# Locate the IP address of the user
class Locator

  # Including their module so we have access to
  # their helper methods
  include HTTParty

  attr_accessor :response
  # freegeoip.net/json/{IP_or_hostname}

  BASE_URI ='https://freegeoip.net'

  def get_location(ip_addr)
    @response = HTTParty.get("#{BASE_URI}/json/#{ip_addr}")
  end
end


