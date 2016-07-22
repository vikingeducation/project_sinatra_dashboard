require 'httparty'

module Locator
  class Locator
    def initialize(ip_address)
      @ip_address = ip_address
      @geo_info = get_geo_info(@ip_address)
    end

    def get_geo_info(ip_address)
      HTTParty.get("http://ip-api.com/json/#{ip_address}")
    end

    def zip
      @geo_info['zip']
    end

    def city
      @geo_info['city']
    end

    def region
      @geo_info['region']
    end
  end
end

l = Locator::Locator.new('24.6.2.241').zip
p l