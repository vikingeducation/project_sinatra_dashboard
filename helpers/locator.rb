require 'httparty'
require 'pp'

class Locator
  BASE_URI = 'https://freegeoip.net'
  FORMAT = 'json'

  def locate(ip_address)
    response = HTTParty.get("#{BASE_URI}/#{FORMAT}/#{ip_address}")
  end
end

if $0 == __FILE__
  pp Locator.new.locate("www.google.com")
end
