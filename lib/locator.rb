require "mechanize"
require "json"

class Locator
  attr_accessor :agent

  BASE_URI = "http://freegeoip.net"

  def initialize
    @agent = Mechanize.new
  end

  def from_ip(ip)
    url = [BASE_URI, "json", ip].join("/")
    page = agent.get(url)
    JSON.parse(page.body)
  end

  def location(ip)
    d = from_ip(ip)
    [d["city"], d["region_name"], d["country_name"]].join(", ")
  end

end
