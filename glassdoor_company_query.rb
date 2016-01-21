

require 'httparty'
require 'pp'

class GlassdoorCompanyQuery
  BASE_STRING = "http://api.glassdoor.com/api/api.htm"
  
  attr_accessor :ip_or_domain
  attr_reader :ip_response, :glassdoor_response

  def initialize( partner_id, key, query_company )
    @partner_id = partner_id
    @key = key
    @partner_str = "t.p=" + @partner_id
    @key_str =  "t.k=" + @key
    @query_str = "q="+ query_company
    @userip_str = "userip=0.0.0.0"
    @useragent_str = "useragent="
    @format_str = "format=json"
    @version_str = "v=1"
    @action_str = "action=employers"
  end

  def make_request

    query_array = [
      @partner_str,
      @key_str, 
      @query_str,
      @userip_str,
      @useragent_str,
      @format_str,
      @version_str,
      @action_str
    ]
    request_string = BASE_STRING + "?" + query_array.join("&")
    @glassdoor_response = HTTParty.get( request_string )

  end

end


query = GlassdoorCompanyQuery.new( "53058", "sKW4n63kz1", "Intel")
query.make_request
pp query.glassdoor_response

File.open("glassdoor_output.txt","w") do |f|
  PP.pp(query.glassdoor_response,f)
end
