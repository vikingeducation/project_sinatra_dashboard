require 'typhoeus'
require 'json'

module LocatorHelper
  class Locator
    def self.send_request(ip_address)
      Typhoeus::Request.new("freegeoip.net/json/#{ip_address}", :method => :get)
    end
  end
end
