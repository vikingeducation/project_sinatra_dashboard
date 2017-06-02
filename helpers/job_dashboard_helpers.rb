require_relative './locator'

module JobDashboardHelpers
  def request_ip
    if settings.development?
      "202.40.249.81"
    else
      request.ip
    end
  end

  def save_visitor(city, country)
    session[:visitor_city] = city
    session[:visitor_country] = country
  end

  def load_visitor(ip_address)
    if session[:visitor_city] && session[:visitor_country]
      return [session[:visitor_city], session[:visitor_country]]
    else
      geodata = Locator.new.locate(ip_address)
      return [geodata["city"], geodata["country_name"]]
    end
  end
end
