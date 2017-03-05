require 'json'
require 'pry'
require 'envyable'
require 'httparty'


Envyable.load('./config/env.yml', 'development')

class CompanyProfiler

  URL_START = "http://api.glassdoor.com/api/api.htm?"
  VERSION = "1"
  FORMAT = "json"
  TP = ENV["PARTNER_ID"]
  TK = ENV["PARTNER_KEY"]
  USERIP = "169.156.91.245"
  USERAGENT = ENV["HTTP_USER_AGENT"]
  ACTION = "employers"

  def initialize # really don't need here since empty of code
  end

  def get_reviews(company_name, location) 

    @company_name = company_name
    @location = location
    company_reviews = []

    url = build_url
    response = HTTParty.get(url)

    if response.code == 200
      return company_reviews unless response.parsed_response["response"]["employers"] && response.parsed_response["response"]["employers"][0]
      company_reviews = 
      [
      culture_and_values = response.parsed_response["response"]["employers"][0]["cultureAndValuesRating"],
      compensation_and_benefits = response.parsed_response["response"]["employers"][0]["compensationAndBenefitsRating"],
      career_opportunities = response.parsed_response["response"]["employers"][0]["careerOpportunitiesRating"],
      work_life_balance = response.parsed_response["response"]["employers"][0]["workLifeBalanceRating"],  
      if review_headline = response.parsed_response["response"]["employers"][0]["featuredReview"]
        review_headline = response.parsed_response["response"]["employers"][0]["featuredReview"]["headline"].gsub(/\r\n?/, " "),
        review_pros = response.parsed_response["response"]["employers"][0]["featuredReview"]["pros"].gsub(/\r\n?/, " "),
        review_cons = response.parsed_response["response"]["employers"][0]["featuredReview"]["cons"].gsub(/\r\n?/, " ")
      end
      ]
    end
    company_reviews
  end

  def build_url
    query = []
    [
      ["v", VERSION],
      ["format", FORMAT],
      ["action", ACTION],
      ["t.p", TP],
      ["t.k", TK],
      ["userip", USERIP],
      ["useragent", USERAGENT],
      ["action", ACTION],
      ["q", @company_name],
      ["l", @location]  
    ].each do |parameter|
      query << parameter.join("=")
    end
    url = URL_START + query.join("&")
  end



end



