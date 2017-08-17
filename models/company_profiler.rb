# /models/company_profiler.rb
require 'rubygems'
require 'httparty'
require './environment.rb'

# CompanyProfiler
class CompanyProfiler
  def initialize(company_name, zip_code)
    @company_name = company_name
    @company_data = {}
    @location = zip_code
    @base_url = "http://api.glassdoor.com/api/api.htm?"
  end

  # parse_data
  def get_data
    @company_data = parse_data(send_request)
    ["4.6","2.4","boomshackalacka"]
  end

  private

  # parse_data
  def parse_data(response)
    # parses response hash from api and returns data
    response = send_request
    response["response"]["employers"][0]
  end

  # send_request
  def send_request
    # sends an request to the glassdoor api and returns a hash
    partner_id = GD_PARTNER_ID
    api_key = GD_PARTNER_KEY
    url = "http://api.glassdoor.com/api/api.htm?t.p=#{partner_id}&t.k=#{api_key}&userip=0.0.0.0&useragent=&format=json&v=1&action=employers&q=#{@company_name}&l=#{@location}"
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end

end
