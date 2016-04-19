CompanyData = Struct.new(:cultureAndValuesRating, :compensationAndBenefitsRating, :workLifeBalanceRating)

GD_PARTNER_ID = ENV["glassdoor_partner_id"]
GD_KEY = ENV["glassdoor_key"]

class Locator
  include HTTParty
  BASE_URI = "http://ip-api.com/json"

  def find_location( ip )
    response = self.class.get(BASE_URI + "/#{ip}")
  end
end

class CompanyProfiler
  def self.search( company, request )
    link = "http://api.glassdoor.com/api/api.htm?t.p=#{"61481"}&t.k=#{"jMMK2dvsJW7"}&userip=#{request.cookies["ip"]}&useragent=#{request.cookies["user_agent"]}&format=json&v=1&action=employers&q=#{company}"
    response = HTTParty.get(link)
  end
end
