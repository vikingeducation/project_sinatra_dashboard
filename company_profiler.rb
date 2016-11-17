require "figaro"
require 'httparty'


# PARTNER = Figaro.env.Partner_ID
# p PARTNER

class CompanyProfiler

  ENDPOINT = 'http://api.glassdoor.com/api/api.htm?'

  def search(company_name, location, ip, agent)

    url = ENDPOINT + '1.1' + 'json' + 

    options = { 'v' => '1.1', 'format' => 'json', 't.p' => ENV['partner_id'], 't.k' => ENV['key'], 'userip' => ip, 'useragent' => agent, 'action' => 'employers', 'q' => company_name, 'l' => location }

    json = HTTParty.get(url, options)
    parser(json)

  end

  def parser(json)
    p json
  end

  # takes a query 

  # gets company data from Glassdoor on a company by name

  # return culture rating, values rating, compensation and benefits rating, featured review, url of page in an array

end
