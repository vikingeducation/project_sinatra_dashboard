require 'httparty'

class CompanyProfiler

  include HTTParty

  def initialize
    @options = { :query => {:q => query, :l => location }}
  end

  def 

  end
end

# http://api.glassdoor.com/api/api.htm?t.p={partner_id}&t.k={partner_key}&userip={user's ip address}&useragent=&format=json&v=1&action=employers&q={query phrase}&l={location}&pn={page number}&ps={page size}