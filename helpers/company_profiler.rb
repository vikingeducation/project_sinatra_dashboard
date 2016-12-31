require 'httparty'

class CompanyProfiler

  attr_reader :profile

  PARTNER_ID = ENV["PARTNER_ID"]
  PARTNER_KEY = ENV["PARTNER_KEY"]
  END_POINT = "http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=#{PARTNER_ID}&t.k=#{PARTNER_KEY}"

def initialize(company, user_ip, user_agent)
  url = build_url(company, user_ip, user_agent)
  @profile = build_profile(url)
end

def build_profile(url)
  sleep(0.5)
  data = HTTParty.get(url)
  data["response"]["employers"].first
end

def name
  @profile["name"]
end

def featured_review
  @profile["featuredReview"]
end

def overall_rating
  @profile["overallRating"]
end

def culture_and_values
  @profile["cultureAndValuesRating"]
end

def senior_leadership
  @profile["seniorLeadershipRating"]
end

def compensation_and_benefits
  @profile["compensationAndBenefitsRating"]
end

def career_opps
  @profile["careerOpportunitiesRating"]
end

def work_life_balance
  @profile["workLifeBalanceRating"]
end
def recommend_to_friend
  @profile["recommendToFriendRating"]
end

  private

def build_url(company, user_ip, user_agent)
"#{END_POINT}&action=employers&q=#{company}&userip=#{user_ip}&useragent=#{user_agent}"
end

end