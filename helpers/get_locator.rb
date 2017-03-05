require 'json'
require 'pry'
# require 'httparty'

# get location from client IP address

class Locator

  def initialize # method really not necessary since empty
  end

  def get_locator(ip)
    # binding.pry
    company_data = HTTParty.get("http://freegeoip.net/json/#{ip}")
      # company_data.history_added = Proc.new{sleep 0.5}
      # assignment implies use of this - really not necessary  
      # since API's expect any use rate up to their quota
    zip_code = company_data.parsed_response["zip_code"]
    zip_code
  end

end
