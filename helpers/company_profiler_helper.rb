require_relative './env_helper'
require_relative './job_helpers'

module CompanyProfiler
  class CompanyProfiler
    include JobHelpers

    def initialize()

    end

    def get_url(parameters)
      build_url("http://api.glassdoor.com/api/api.htm?", parameters)
    end

    def get_request(company)
      parameters =
      {
        'v' => '1',
        'format' => 'json',
        't.p' => "#{$GLASSDOOR_ID}",
        't.k' => "#{$GLASSDOOR_KEY}",
        'action' => 'employers',
        'q' => "#{company}"
      }

      @request = HTTParty.get(get_url(parameters))["response"]["employers"].first

    end

    def overall_rating
      @request["overallRating"]
    end

    def culture_rating
      @request["cultureAndValuesRating"]
    end

    def leadership_rating
      @request["seniorLeadershipRating"]
    end

    def compensation_rating
      @request["compensationAndBenefitsRating"]
    end

    def career_ops_rating
      @request["careerOpportunitiesRating"]
    end

    def balance_rating
      @request["workLifeBalanceRating"]
    end
  end
end

