require 'httparty'

class GeoLocation
  include HTTParty

  attr_reader :response

  def initialize(ip)
    @url = "http://freegeoip.net/json/#{ip}"
    @response = self.class.get(@url)
  end

end
