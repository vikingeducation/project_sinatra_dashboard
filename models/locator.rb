require 'httparty'

class Locator
  attr_reader :response
  def initialize(ip)
    @ip = ip
  end

  def get_response
    @response = HTTParty.get("http://freegeoip.net/json/#{@ip}")
  end


end
