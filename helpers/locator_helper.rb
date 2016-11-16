
module LocatorHelper

  def get_IP_location(ip_address)
    ip_address = '146.63.99.201' if settings.development?

    response = Net::HTTP.get("freegeoip.net", "/json/#{ip_address}")

    response['city']
  end
end
