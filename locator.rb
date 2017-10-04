require 'mechanize'
require 'json'

class Locator

  def initialize
      @agent = Mechanize.new
      @agent.history_added = Proc.new { sleep 0.9 }
  end

  def find(ip)
    result = JSON::load(@agent.get("http://www.telize.com/geoip/#{ip}").body)
    if result && result["city"] && result["region_code"]
      return result["city"] + ", " + result["region_code"]
    else
      return nil
    end
  end
end