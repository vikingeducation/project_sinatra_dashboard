require 'httparty'
require 'json'

# For better debugging
require 'pp'

class IPLocator

  # Supported formats are: csv, xml, json and jsonp. If no IP or hostname is provided, then your own IP is looked up.
  # Only going to use JSON for this.
  BASE_URI = "http://freegeoip.net/json/"

  # Construct and initiate the new request
  def get_user_location_details(ip)
    # Build our URL
    uri = "#{BASE_URI}#{ip}"
    # Build the request
    HTTParty.get(uri)
  end

end