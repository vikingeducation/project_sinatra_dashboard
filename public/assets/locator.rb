require 'httparty'
class Locator
  include HTTParty

  base_uri "freegeoip.net"

  def initialize(ip_address)
    @ip_address = ip_address
  end

  def get_location
    self.class.get("/json/#{@ip_address}")
  end
end