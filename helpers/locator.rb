require 'httparty'

class Locator
  attr_reader :ip, :city, :state, :zip_code

  def initialize(ip = nil)
    response = HTTParty.get("http://freegeoip.net/json/#{ip}")
    @ip = response.parsed_response['ip']
    @city = response.parsed_response['city']
    @state = response.parsed_response['region_code']
    @zip_code = response.parsed_response['zip_code']
  end
end