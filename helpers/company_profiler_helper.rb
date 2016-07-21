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

    def make_request(company)
      parameters =
      {
        'v' => '1',
        'format' => 'json',
        't.p' => "#{$GLASSDOOR_ID}",
        't.k' => "#{$GLASSDOOR_KEY}",
        'action' => 'employers',
        'q' => "#{company}"
      }
      
      HTTParty.get(get_url(parameters))
    end

  end
end