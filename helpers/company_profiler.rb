require 'httparty'
require 'pp'
require_relative 'company'

class CompanyProfiler

  attr_reader :company_info, :company

  include HTTParty
  base_uri 'http://api.glassdoor.com'

  def initialize(company_name)
    @company_name = company_name
    @options = { :query => { :v => 1, :format => 'json', :"t.p" => 53055, :"t.k" => "iNUUCFXuQUM", :action => "employers", :q => @company_name }}
    company_ratings
  end


  def company_ratings
    @glassdoor_info = self.class.get("/api/api.htm?", @options)
    stuff_we_want = @glassdoor_info["response"]["employers"][0]
    @company = Company.new(overallRating: stuff_we_want["overallRating"], cultureAndValuesRating: stuff_we_want["cultureAndValuesRating"], compensationAndBenefitsRating: stuff_we_want["compensationAndBenefitsRating"], pros:stuff_we_want["featuredReview"]["pros"][0..200], cons:stuff_we_want["featuredReview"]["cons"][0..200])
    # pp stuff_we_want
  end

end

# http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=53055&t.k=iNUUCFXuQUM&action=employers&q=microsoft

# http://api.glassdoor.com/api/api.htm?t.p=5317&t.k=n07aR34Lk3Y&userip=0.0.0.0&useragent=&format=json&v=1&action=employers


# cp = CompanyProfiler.new("microsoft")
# pp cp.company_ratings
# pp cp.stuff_we_want