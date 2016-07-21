require 'httparty'
require 'pry'

module LocatorHelper

  class Locator
    attr_writer :ip_address
    FORMAT = "json"

    def get_user_address(request)
      binding.pry
      @ip_address = request.ip
    end

    def get_location
      response = HTTParty.get("freegoip.net/#{FORMAT}/#{@ip_address}")
    end

  end


end