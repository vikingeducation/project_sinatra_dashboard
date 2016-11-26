module Locator
  def get_ip_location
    ip = request.ip
    ip = '156.74.181.208' # if development?
    url = "http://freegeoip.net/json/" + "#{ip}"
    geo_object = HTTParty.get(url)
    geo_object['city']
  end
end