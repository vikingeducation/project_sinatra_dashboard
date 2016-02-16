require 'httparty'
require 'json'

# For better debugging
require 'pp'

class IPLocator

  BASE_URI = "http://freegeoip.net/json/" #/{format}/{IP_or_hostname} freegeoip.net/json/github.com
  # Supported formats are: csv, xml, json and jsonp. If no IP or hostname is provided, then your own IP is looked up.

  # Only going to use JSON for this.

  # Construct and initiate the new request
  def get_user_location_details(ip)

    # Build our URL
    uri = "#{BASE_URI}#{ip}"

    # Build the request
    request = HTTParty.get(uri)
  end

end