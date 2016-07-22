#helpers.rb
require 'uri'
require 'httparty'

class Locator
  attr_reader :location

  def initialize(ip="173.68.17.225")
    @location = HTTParty.get("https://freegeoip.net/json/#{ip}")
  end
end

class CompanyProfiler
  #Partner ID:  80591
  #Key:  f6KXrJi3ObW
  END_POINT = "http://api.glassdoor.com/api/api.htm?t.p=80591&t.k=f6KXrJi3ObW&userip=192.168.43.42&useragent=chrome&format=json&v=1&action=employers"

  attr_reader :response

  def initialize(company, location)
    @q = URI.encode(company)
    @l = URI.encode(location)
    @response = HTTParty.get(build_url)
  end

  def build_url
    "#{END_POINT}&q=#{@q}&l=#{@l}"
  end

  def get_company_info
    c_v_rating = "N/A"
    c_b_rating = "N/A"
    featured_pros = "N/A"
    featured_cons = "N/A"

    if start = @response["response"]["employers"][0]
      c_v_rating = start["cultureAndValuesRating"] 
      c_b_rating = start["compensationAndBenefitsRating"] 
      if start["featuredReview"]
         featured_pros = start["featuredReview"]["pros"].nil? ? "N/A" : start["featuredReview"]["pros"]
         featured_cons = start["featuredReview"]["cons"].nil? ? "N/A" : start["featuredReview"]["cons"]
      end
    end
  
    
    [c_v_rating, c_b_rating, featured_pros, featured_cons]
  end




end