require 'httparty'

module CompanyProfileHelper

  class CompanyProfiler

    def initialize(request)
      options = {"v" => 1, 
                "format" => "json", 
                "t.p."=> ENV["GLASSDOOR_ID"], 
                "t.k." => ENV["GLASSDOOR_KEY"], 
                "userip" => request.ip, 
                "useragent" => request.user_agent,
                "action" => "employers"}
    end

    def build_url(query)
    end

  end


end