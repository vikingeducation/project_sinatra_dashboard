require 'httparty'

module DashboardHelper

  def get_location(ip)
    url = "https://freegeoip.net/json/#{ip}"
    location = HTTParty.get(url)["city"]
  end

  def random_ip_generator
    Array.new(4){rand(256)}.join('.')
  end

  def save_sessions(location)
    session[:location] = location
  end

  def load_sessions
    session[:location]
  end

end