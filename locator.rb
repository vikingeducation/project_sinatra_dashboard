class Locator
  def initialize
    @response = HTTParty.get("http://freegeoip.net/json/199.33.32.40")
  end

  def current_location
    current_city = @response["city"]
    current_state = @response["region_code"]
    "#{current_city}, #{current_state}"
  end
end