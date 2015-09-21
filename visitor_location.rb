require 'httparty'

class VisitorLocation

  include HTTParty

  def best_location(ip)
    location = get_location(ip)
    if location["postal_code"]
      location["postal_code"]
    elsif location["region"]
      location["region"]
    else 
      location["country_code"]
    end
  end

  
  private


  def get_location(ip)
    base_url = "http://www.telize.com/geoip"
    puts "getting location for #{ip}"
    self.class.get(base_url + ip)
  end

end
