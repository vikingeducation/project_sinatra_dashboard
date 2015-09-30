require 'json'
require 'httparty'
require 'pp'

class Locator
  attr_accessor :location, :ip
  def initialize
  end

  def get_ip
    request_uri = 'http://www.telize.com/ip'
    @ip = HTTParty.get(request_uri)
  end

  def get_location(ip = nil)
    ip = @ip if ip.nil?
    request_uri = "http://www.telize.com/geoip/#{ip}"
    @location = HTTParty.get(request_uri)
  end
end

