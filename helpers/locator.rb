require 'httparty'
require 'pp'

class GPSLocator

  include HTTParty

    BASE_URI = "http://freegeoip.net/json/"

  def initialize(ip)
    @ip = ip
    @options = {query:{ip: @ip} }
  end

  def get_raw_response
    HTTParty.get(BASE_URI, @options)
  end

end