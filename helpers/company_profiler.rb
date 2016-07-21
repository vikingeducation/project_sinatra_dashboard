require 'httparty'

module CompanyProfileHelper
  attr_reader :base_uri

  API_KEY = ENV["API_KEY"]

  class CompanyProfiler
    #@response = HTTPParty.class.get("#{VERSION}", options)
    def initialize(request)
      @base_uri = "http://api.glassdoor.com/api/api.htm"
      @query_params = {
                      "t.p" => '80567',
                      "t.k" => 'hpTny2kiC7E',
                      "userip" => request.ip,
                      "useragent" => request.user_agent,
                      "format" => "json",
                      "v" => '1',  
                      "action" => "employers"
                      #ENV["GLASSDOOR_ID"], 
                      #ENV["GLASSDOOR_KEY"], 
                      }
    end

    def build_url(query)
      @query_params.keys.each do |k|
        @base_uri += "#{k}=#{@query_params[k]}&"
      end
      @base_uri = @base_uri[0..-2] + "q=#{query}"
      binding.pry
    end

    def get_request
      HTTParty.get(@base_uri)
    end

  end


end