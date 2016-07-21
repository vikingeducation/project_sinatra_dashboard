require 'httparty'

module CompanyProfileHelper
  attr_reader :base_uri

  API_KEY = ENV["API_KEY"]

  class CompanyProfiler
    
    def initialize(request)
      @query_params = {
                      "t.p" => '80567',
                      "t.k" => 'hpTny2kiC7E',
                      "userip" => request.ip,
                      "useragent" => request.user_agent,
                      "format" => "json",
                      "v" => '1',  
                      "action" => "employers" 
                      }
    end

    def get_all_info(query)
      @base_uri = "http://api.glassdoor.com/api/api.htm?"
      @query_params.keys.each do |k|
        @base_uri += "#{k}=#{@query_params[k]}&"
      end
      build_url(query)
      results = get_request
      get_company_info(results)
      
    end

    def get_company_info(results)
      company_info = {}
      company_info[:name] = get_company_name(results)
      company_info[:rating] = get_rating(results)
      company_info[:website] = get_website(results)  
      company_info[:industry] = get_industry(results)
      company_info[:pros] = get_pros(results)
      company_info[:cons] = get_cons(results)
      company_info
    end  

    def build_url(query)
      @base_uri = @base_uri[0..-2] + "&q=#{query}"
    end

    def get_request
      @response = HTTParty.get(@base_uri,:headers=>{"User-Agent" => @query_params["useragent"]})
    end

    def get_company_name(results)
      results["response"]["employers"][0]["name"]
    end

    def get_rating(results)
      results["response"]["employers"][0]["overallRating"]
    end

    def get_website(results)
      results["response"]["employers"][0]["website"]
    end

    def get_industry(results)
      results["response"]["employers"][0]["industry"]
    end

    def get_pros(results)
      results["response"]["employers"][0]["featuredReview"]["pros"]
    end

    def get_cons(results)
      results["response"]["employers"][0]["featuredReview"]["cons"]
    end

  end


end







