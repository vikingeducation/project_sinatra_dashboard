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
    session[:city] = city
    session[:country] = country
  end

  def load_visitor(ip_address)
    if session[:city] || session[:country]
      return [session[:city], session[:country]]
    else
      geodata = Locator.new.locate(ip_address)
      return [geodata["city"], geodata["country_name"]]
    end
  end
end
