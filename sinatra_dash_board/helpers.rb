#helpers.rb

class Locator
  attr_reader :location

  def initialize(ip="173.68.17.225")
    @location = HTTParty.get("https://freegeoip.net/json/#{ip}")
  end
end

class CompanyProfiler
  #Partner ID:  80591
  #Key:  f6KXrJi3ObW

  def initialize(query)
http://api.glassdoor.com/api/api.htm?t.p=80591&t.k=f6KXrJi3ObW&userip=192.168.43.42&useragent=chrome&format=json&v=1&action=employers&l=chicago&q=Hirewell
    http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=80591&t.k=f6KXrJi3ObW&action=companies&q=pharmaceuticals&userip=192.168.43.42&useragent=Chrome/%2F4.0
    http://api.glassdoor.com/api/api.htm?
    v=1
    &format=json&t.p=120
    &t.k=fz6JLNDfgVs
    &action=employers
    &q=pharmaceuticals
    &userip=192.168.43.42
    &useragent=Mozilla
    /%2F4.0
    #
  end

end