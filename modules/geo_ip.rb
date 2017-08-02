require 'typhoeus'
require 'httparty'
require 'json'

class GEOIP

  def initialize(ip)
    @ip_addy = ip
  end

  def location_info
    response = send_request
    response_body = JSON.parse(response.body)
    pp response_body
    location = []
    location << response_body["city"] << response_body["region_code"]
    location.join(",")
  end

  def send_request
    uri = "freegeoip.net/json/" + @ip_addy
    request = Typhoeus::Request.new( uri,
                                     method: :get,
                                    )
    request.run
    request.response
  end

end # end of class
