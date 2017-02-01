require 'httparty'

class CompanyProfiler
  include HTTParty
  base_uri 'api.glassdoor.com'

  attr_reader :employers

  def initialize(query)
    @options = { query: { v: '1', format: 'json' , 't.p': ENV['GLASSDOOR_PARTNER_ID'], 't.k': ENV['GLASSDOOR_KEY'], action: 'employers', q: query } }
    response = get_info
    @employers = response.parsed_response['response']['employers']
  end

  def get_info
    self.class.get('/api/api.htm', @options)
  end
end