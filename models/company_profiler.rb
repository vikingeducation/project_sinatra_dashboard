# ./models/company_profiler.rb
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'httparty'

class CompanyProfiler

  include HTTParty

  BASE_URI = 'http://api.glassdoor.com/api/api.htm'
  # PARTNER_ID = ENV["PARTNER_ID"]
  # API_KEY = ENV["API_KEY"]
  
  attr_accessor :params, :response, :featured_response

  def initialize(company, partner_id, api_key)
    @params = 
    {query: 
      {v: "1",
      format: "json",
      # "t.p": PARTNER_ID,
      # "t.k": API_KEY,
      "t.p": partner_id,
      "t.k": api_key,
      action: "employers",
      q: company,
      userip: "0.0.0.0",
      useragent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
      }
    }
    puts "the query string #{@params}"
    temp_json = HTTParty.get(BASE_URI, @params)
    parse_response(temp_json) if response_valid?(temp_json)
  end

  def response_valid?(temp)
    temp["success"] == true && temp["status"] == "OK"
  end

  def parse_response(temp)
     @response = temp["response"]["employers"].first
     puts "#" 
  end

  def culture_rating
    @response["cultureAndValuesRating"]
  end

  def compensation_rating
    @response["compensationAndBenefitsRating"]
  end

  def work_life_rating
    @response["workLifeBalanceRating"]
  end

  def career_rating
    @response["careerOpportunitiesRating"]
  end

  def overall_rating
    @response["overallRating"]
  end

  def featured_review?
    jobtitle = ""
    headline = ""
    overall = ""

    if !@response["featuredReview"].nil?
      jobtitle = @response["featuredReview"]["jobTitle"]
      headline = @response["featuredReview"]["headline"]
      overall = @response["featuredReview"]["overallNumeric"]
    end

    @featured_response = 
      {:jobtitle => jobtitle,
      :headline => headline, 
      :overall => overall
    }
  end

end
