
require 'httparty'
require 'pp'

class IPGeoLocation
  attr_accessor :ip_or_domain
  attr_reader :ip_response

  def initialize( domain="drudgereport.com")
    @ip_or_domain = domain
    @ip_response = make_request
  end

  def make_request
    request_string = "http://freegeoip.net/json/"
    request_string = request_string + @ip_or_domain.to_s
    # print request_string
    HTTParty.get( request_string )
  end

  def print
    pp @ip_response
  end



end

# my_ip = "71.32.162.164"
# my_ip = "drudgereport.com"
# query = IPGeoLocation.new( my_ip )
# query.print
