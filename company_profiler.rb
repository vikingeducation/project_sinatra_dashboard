class CompanyProfiler

  require 'json'
  require 'httparty'

  include HTTParty

  base_uri "http://api.glassdoor.com"
  API_ID = ENV["GLASSDOOR_API_ID"]
  API_KEY = ENV["GLASSDOOR_API_KEY"]



  def initialize
    @options = { query: { :'t.p'      => API_ID,
                          :'t.k'      => API_KEY,
                          :userip     => "0.0.0.0",
                          :useragent  => "",
                          :format     => "json",
                          :v          => "1",
                          :action     => "employers"
                        }
                }
    @response = {}
  end


  def fetch_data(company)
    search = @options
    search[:query][:q] = company
    @response = self.class.get("/api/api.htm", search)
  end


  def rating_overall
    @response[:response][:employers][:overallRating]
  end

# Example request ~ http://api.glassdoor.com/api/api.htm?t.p=38330&t.k=bDBBAwJbDEI&userip=0.0.0.0&useragent=&format=json&v=1&action=employers&q=google




end