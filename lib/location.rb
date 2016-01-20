require 'httparty'

class Location
  include HTTParty

  base_uri 'freegeoip.net/json/'

  def self.location_for(ip_address)
    get("/#{ip_address}")
  end
end


