require 'httparty'

class Locator
  attr_reader :ip_address
  
  def initialize(ip)
    @ip_address = ip
  end

  def send_request
    HTTParty.get("freegeoip.net/json/#{ip_address}")
  end

end