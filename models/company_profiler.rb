# /models/company_profiler.rb
require 'rubygems'
require 'mechanize'

# CompanyProfiler
class CompanyProfiler
  def initialize(company_name = nil)
    @company_name = company_name
    @company_data = {}
  end

  # get_data
  def get_data
    # parses response hash from api and returns data when
  end


  # send_request
  def send_request
    # sends an request to the glassdoor api and returns a hash
  end




end
