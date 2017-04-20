require_relative "./helpers/glassdoor_key_helper"
class CompanyProfiler

  attr_reader :response

  def initialize(company)
    @response = HTTParty.get("http://api.glassdoor.com/api/api.htm?
      v=1&format=json&t.p=#{PARTNER_ID}&t.k=#{KEY}&action=employers&q=#{company}")["response"]["employers"][0]
  end 

  def overall_rating
    @response["overallRating"] 
  end

  def culture_rating
    @response["cultureAndValuesRating"]
  end

  def compensation_rating
    @response["compensationAndBenefitsRating"]
  end

  def work_balance_rating
    @response["workLifeBalanceRating"]
  end

end
