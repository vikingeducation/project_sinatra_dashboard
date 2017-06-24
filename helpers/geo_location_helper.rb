# ./helpers/GeoLocationHelper
module GeoLocationHelper
  def get_id
    if settings.development?
      # "51.101.60.235"
      "90.223.204.82"
    else
      request.ip
    end
  end


  def get_city(ip_details)
    (ip_details["city"].empty?) ? "London" : ip_details["city"]
  end

  def get_country(ip_details)
    (ip_details["country_name"].empty?) ? "United Kingdom" : ip_details["country_name"]
  end
end