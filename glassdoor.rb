require 'rubygems'
require 'HTTParty'
class GlassDoor

  def initialize

  end

  def make_url(company_name, ip)
    base_url = 'http://api.glassdoor.com/api/api.htm?v=1&format=json'
    partner_id = "&t.p=#{ENV['GDPARTNER']}"
    partner_key = "&t.k=#{ENV['GLASSDOOR']}"
    action = '&action=employers'
    q = "&q=#{company_name}"
    ip = "&userip=#{ip}"
    user_agent = '&useragent=Mozilla/%2F4.0'
    url = base_url + partner_id + partner_key + action + q + ip + user_agent
  end

  def make_request(url)
    result = HTTParty.get(url)
  end



end

g = GlassDoor.new
url = g.make_url('', '86.169.13.160')
p url
result = g.make_request(url)
p result