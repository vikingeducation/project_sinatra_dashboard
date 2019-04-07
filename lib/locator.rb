class Locator
  attr_reader :city, :region, :zip

  def initialize
  end

  def get_api_location(ip)
    response = HTTParty.get("https://freegeoip.net/json/#{ip}")
    @city = "#{response['city']}"
    @region = "#{response['region_code']}"
    @zip = "#{response['zip_code']}"
  end
end
