CompanyData = Struct.new(:cultureAndValuesRating, :compensationAndBenefitsRating, :workLifeBalanceRating)


class Locator
  include HTTParty
  BASE_URI = "http://ip-api.com/json"

  def find_location( ip )
    response = self.class.get(BASE_URI + "/#{ip}")
  end
end


class CompanyProfiler
  # Putting ENV variables doesnt work here

  def self.search( ip, user_agent, company )
    link = "http://api.glassdoor.com/api/api.htm?t.p=#{ENV["GD_PARTNER_KEY"]}&t.k=#{ENV["GD_KEY"]}&userip=#{ip}&useragent=#{user_agent}&format=json&v=1&action=employers&q=#{company}"
    response = HTTParty.get(link)
  end
end
