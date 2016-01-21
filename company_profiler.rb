

require 'httparty'
require 'pp'

class CompanyProfiler
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
    @glassdoor_response = nil
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

  def parse_response
    company_ratings = []
    current_company = []

    company_array = @glassdoor_response["response"]["employers"]

    company_array.each do |company|
      if company["exactMatch"]
        current_company << company
        break
      end
    end

    if current_company.empty?
      return nil
    end

    current_company = current_company[0]
    company_ratings << current_company["overallRating"]
    company_ratings << current_company["cultureAndValuesRating"]
    company_ratings << current_company["compensationAndBenefitsRating"]
    r = current_company["featuredReview"]
    company_ratings << [r["pros"], r["cons"], r["overall"]]
    return company_ratings
  end
end

# credentials = File.read("glassdoor_api.txt")
# result = credentials.split("\n")
# partner_id = result[0]
# api_key = result[1]
#
# query = CompanyProfiler.new( partner_id, api_key, "Intel")
# query.make_request
# query.glassdoor_response
# pp query.parse_response


# File.open("glassdoor_output.txt","w") do |f|
#   PP.pp(query.glassdoor_response,f)
# end
