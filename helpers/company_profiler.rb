require './env.rb'
require 'typhoeus'
require 'json'

class CompanyProfiler

  def initialize(query)
    @query = query
    @partner_id = PARTNER_ID
    @api_key = API_KEY
  end

  def send_request
    Typhoeus::Request.new(build_uri, :method => :get)
  end


  def build_uri
    "http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=#{PARTNER_ID}&t.k=#{API_KEY}&action=employers&q=pharmaceuticals&userip=192.168.43.42&useragent=Mozilla/%2F4.0"

  end

end




#http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120&t.k=fz6JLNDfgVs&action=employers&q=pharmaceuticals&userip=192.168.43.42&useragent=Mozilla/%2F4.0