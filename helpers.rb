module RequestHelper
  def location_string(loc)
    unless loc == ""
      return "Searching for jobs in #{loc}."
    else
      return "Searching for jobs..."
    end
  end

  def get_location(loc, ip)
    return loc unless loc.empty?
    locator = Locator.new
    res = locator.find(ip)
    return res unless res.nil?
    return ""
  end

  def get_ip(ip)
    if ip == "127.0.0.1"
      return File.readlines("ip.txt")[0]
    else
      return ip
    end
  end
end