require 'httparty'
require 'json'

module Locator

  BASE_URI = "http://freegeoip.net/json/"

  def self.get_location(ip = "68.50.202.219")
    free_geo_json = get_free_geo(ip)
    parse_free_geo_data(free_geo_json)
  end

  private

    def self.get_free_geo(ip)
      HTTParty.get("#{ BASE_URI }#{ ip }").body
    end

    def self.parse_free_geo_data(json)
      location_data = JSON.parse(json)
      "#{location_data["city"]}, #{location_data["region_code"]}"
    end
end
