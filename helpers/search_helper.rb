module SearchHelper

  def find_ip
    ip = @env["REMOTE_ADDR"]
    user_agent = @env["HTTP_USER_AGENT"]
    locator = Locator.new
    ip = "208.80.152.201" if ip == "::1"
    ip_response = locator.find_location( ip )
    @city = ip_response["city"].split(" ").join("_")
    @country_code = ip_response["countryCode"]
    { ip: ip, user_agent: user_agent, city: @city, country_code: @country_code }
  end

end