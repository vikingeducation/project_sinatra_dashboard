class CompanyProfiler
  attr_reader :company

  PARTNER_ID = ENV['GLASSDOOR_PARTNER_ID']
  PARTNER_KEY = ENV['GLASSDOOR_KEY']
  BASE_URI = "http://api.glassdoor.com/api/api.htm?v=1&t.p=#{PARTNER_ID}&t.k=#{PARTNER_KEY}&format=json&action=employers&"

  def initialize(company_name, agent, ip)
    @company = get_company(company_name, agent, ip)
  end

  private

  def get_company(company_name, agent, ip)
    uri = "#{BASE_URI}userip=#{ip}&useragent=#{agent}&q=#{company_name}"
    response = HTTParty.get(uri)

    # Pick first company
    response['response']['employers'].first
  end
end