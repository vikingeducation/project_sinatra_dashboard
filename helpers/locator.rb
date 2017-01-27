require 'httparty'

class Locator
  attr_reader :ip, :city, :state

  def initialize(ip = nil)
    response = HTTParty.get("http://freegeoip.net/json/#{ip}")
    @ip = response.parsed_response['ip']
    @city = response.parsed_response['city']
    @state = response.parsed_response['region_code']
  end
end