require 'httparty'

class VisitorLocation

  include HTTParty

  def zipcode(ip)
    location = get_location(ip)
    location["postal_code"]
  end


  private


  def get_location(ip)
    base_url = "http://www.telize.com/geoip"
    self.class.get(base_url + ip)
  end

end
