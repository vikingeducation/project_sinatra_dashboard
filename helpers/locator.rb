require 'httparty'
require 'json'
require 'pry'

class Locator

  def initialize(ip)

    @ip_address = ip

  end

  def find_location

    response = HTTParty.get("http://www.telize.com/geoip/#{@ip_address}")

    [response["city"], response["region_code"],
      response["postal_code"], response["country"]]

  end

end