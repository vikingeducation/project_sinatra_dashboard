class Locator
  attr_reader :city, :region, :zip

  def initialize
  end

  def get_api_location
    response = HTTParty.get("https://freegeoip.net/json/108.185.219.255")
    @city = "#{response['city']}"
    @region = "#{response['region_code']}"
    @zip = "#{response['zip_code']}"
  end
end
