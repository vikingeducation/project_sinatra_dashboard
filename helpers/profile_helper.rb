require './env.rb'
require 'typhoeus'
require 'json'

module ProfilerHelper

  class CompanyProfiler

    def initialize(query)
      @query = query.gsub(' ','+')
      @request = send_request
    end

    def send_request
      request = Typhoeus::Request.new(build_uri, :method => :get)
      request.run.response_body.length > 0 ? JSON.parse(request.run.response_body) : nil
    end

    def build_uri
      "http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=#{PARTNER_ID}&t.k=#{API_KEY}&action=employers&q=#{@query}"
    end

    def find_job
      @request["response"]["employers"].first if @request
    end

    def featured_review
      if @request
        review = find_job["featuredReview"] if find_job["featuredReview"]
        review
      end
    end

    def ratings
      if @request
        job = find_job
        ratings = {}
        ratings["overall"] = job["overallRating"].to_s
        ratings["culture_values"] = job["cultureAndValuesRating"]
        ratings["compensation"] = job["compensationAndBenefitsRating"]
        ratings["worklife"] = job["workLifeBalanceRating"]
        ratings
      end
    end
  end

end




#http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120&t.k=fz6JLNDfgVs&action=employers&q=pharmaceuticals&userip=192.168.43.42&useragent=Mozilla/%2F4.0
