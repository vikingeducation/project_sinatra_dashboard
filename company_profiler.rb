require 'HTTParty'
require 'envyable'
require 'JSON'

Envyable.load('config/env.yml')

Ratings = Struct.new(:count, :overall, :culture, :compensation)
Review = Struct.new(:date, :job_title, :pros, :cons)

class CompanyProfiler

  include HTTParty
  
  API_ID = ENV["glassdoor_id"]
  API_KEY = ENV["glassdoor_key"]
  BASE_URL = "http://api.glassdoor.com/api/api.htm?t.p=" + 
             API_ID + "&t.k=" + API_KEY + 
             "&userip=0.0.0.0&useragent=&format=json&v=1&action=employers" 


  def get_profile(company_name)
    profile = {}
    options = { query: { q: company_name } }

    api_data = self.class.get(BASE_URL, options)
    api_data = JSON.parse(api_data.response.body)
    raw_profile = api_data["response"]["employers"][0]

    # raw_profile will be nil if glassdoor couldn't find a company
    unless raw_profile.nil?

      rating = Ratings.new
      rating.count = raw_profile["numberOfRatings"].to_s
      rating.overall = raw_profile["overallRating"].to_s
      rating.culture = raw_profile["cultureAndValuesRating"]
      rating.compensation = raw_profile["compensationAndBenefitsRating"]
      profile[:ratings] = rating

      if raw_profile["featuredReview"]
        review = Review.new
        raw_review = raw_profile["featuredReview"]
        review.date = Date.parse(raw_review["reviewDateTime"]).strftime("%Y-%m-%d")
        review.job_title = raw_review["jobTitle"]
        review.pros = raw_review["pros"]
        review.cons = raw_review["cons"]
        profile[:review] = review
      end

      profile[:website] = raw_profile["website"]
      profile[:industry] = raw_profile["industryName"]

    end

    profile unless profile.empty?
  end
  
  
end