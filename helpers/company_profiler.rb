require 'httparty'
require 'pp'
require 'figaro'
require_relative 'company'
require_relative 'company_profiler_figaro'


class CompanyProfiler

  attr_reader :company_info, :company

  include HTTParty
  base_uri 'http://api.glassdoor.com'

  GLASSDOOR_TP = ENV['glassdoor_tp']
  GLASSDOOR_TK = ENV['glassdoor_tk']


  def initialize(company_name)
    @company_name = company_name
    @options = { :query => { :v => 1, :format => 'json', :"t.p" => GLASSDOOR_TP, :"t.k" => GLASSDOOR_TK, :action => "employers", :q => @company_name }}

    company_ratings
  end


  def company_ratings
    @glassdoor_info = self.class.get("/api/api.htm?", @options)
    if @glassdoor_info["response"]["employers"][0]
      stuff_we_want = @glassdoor_info["response"]["employers"][0]
      @company = Company.new(overallRating: stuff_we_want["overallRating"], cultureAndValuesRating: stuff_we_want["cultureAndValuesRating"], compensationAndBenefitsRating: stuff_we_want["compensationAndBenefitsRating"], pros: "none", cons: "none")
      # pp stuff_we_want
    end

    if stuff_we_want["featuredReview"]
      @company.pros = stuff_we_want["featuredReview"]["pros"][0..200]
      @company.cons = stuff_we_want["featuredReview"]["cons"][0..200]
    end
  end

end

# http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=53055&t.k=iNUUCFXuQUM&action=employers&q=microsoft

# http://api.glassdoor.com/api/api.htm?t.p=5317&t.k=n07aR34Lk3Y&userip=0.0.0.0&useragent=&format=json&v=1&action=employers


# cp = CompanyProfiler.new("microsoft")
# cp.company_ratings
# pp cp.company