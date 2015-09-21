require 'HTTParty'
require 'envyable'
require 'JSON'

Envyable.load('config/env.yml')

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

    puts "Searching Glassdoor for #{company_name}"
    api_data = self.class.get(BASE_URL, options)
    api_data = JSON.parse(api_data.response.body)
    raw_profile = api_data["response"]["employers"][0]

    # raw_profile will be nil if glassdoor couldn't find a company
    unless raw_profile.nil?

      profile["number_of_ratings"] = raw_profile["numberOfRatings"].to_s
      profile["overall_rating"] = raw_profile["overallRating"].to_s
      profile["culture_rating"] = raw_profile["cultureAndValuesRating"]
      profile["compensation_rating"] = raw_profile["compensationAndBenefitsRating"]

      if raw_profile["featuredReview"]
        raw_review = raw_profile["featuredReview"]
        profile["review?"] = true
        profile["review_date"] = Date.parse(raw_review["reviewDateTime"]).strftime("%Y-%m-%d")
        profile["reviewer_job_title"] = raw_review["jobTitle"]
        profile["review_pros"] = raw_review["pros"]
        profile["review_cons"] = raw_review["cons"]
      else
        profile["review?"] = false
      end

      profile["website"] = raw_profile["website"]
      profile["industry"] = raw_profile["industryName"]

    end

    # want to return nil if Glassdoor couldn't find anything
    profile unless profile.empty?
  end
  
  
end