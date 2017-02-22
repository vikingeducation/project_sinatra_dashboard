require 'httparty'
require 'pp'


class CompanyProfiler

  include HTTParty

    BASE_URI = "http://api.glassdoor.com/api/api.htm?v=1&format=json"

    PARTNER_ID=124372
    GLASS_KEY='c62TkDAnELg'

  # API_KEY = ENV["GLASS_KEY"]
  # ID = ENV["PARTNER_ID"]

  def initialize(company, ip)
    @ip = ip
    @company = company
    @options = {query: {"t.p" => PARTNER_ID, 
                        "t.k" => GLASS_KEY, 
                        "action" => "employers", 
                        "q" => @company, 
                        "userip" => @ip, 
                        "useragent"=> "Mac Safari"} }
  end

  def get_raw_response
      sleep 0.10
      HTTParty.get(BASE_URI, @options)
  end

  def get_ratings
    json_array = self.get_raw_response
    if json_array["response"]["employers"].any?
      array_with_ratings = json_array["response"]["employers"][0]
      {"overallRating" => array_with_ratings["overallRating"],
        "ratingDescription"=> array_with_ratings["ratingDescription"],
        "cultureAndValuesRating"=> array_with_ratings["cultureAndValuesRating"],
        "seniorLeadershipRating"=> array_with_ratings["seniorLeadershipRating"],
        "compensationAndBenefitsRating"=> array_with_ratings["compensationAndBenefitsRating"],
        "careerOpportunitiesRating"=> array_with_ratings["careerOpportunitiesRating"],
        "workLifeBalanceRating"=> array_with_ratings["workLifeBalanceRating"],
        "recommendToFriendRating"=> array_with_ratings["recommendToFriendRating"]}
    else
      {"overallRating" => "n/a",
      "ratingDescription"=> "n/a",
      "cultureAndValuesRating"=>"n/a",
      "seniorLeadershipRating"=> "n/a",
      "compensationAndBenefitsRating"=>"n/a",
      "careerOpportunitiesRating"=> "n/a",
      "workLifeBalanceRating"=> "n/a",
      "recommendToFriendRating"=> "n/a"}
    end
  end

end