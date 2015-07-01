class CompanyProfiler
  # Example request ~ http://api.glassdoor.com/api/api.htm?t.p=38330&t.k=bDBBAwJbDEI&userip=0.0.0.0&useragent=&format=json&v=1&action=employers&q=google

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
  end


  def get_profile(company)
    response = fetch_data(company)

    if response.nil?
      profile = { name: "n/a",
                  ratings: "n/a",
                  review: "n/a"
                }
    else
      profile = { name: company,
                  ratings: get_ratings(response),
                  review: featured_review(response)
                }
    end

    profile
  end


  private


  def fetch_data(company)
    search = @options
    search[:query][:q] = company
    full_response = self.class.get("/api/api.htm", search)

    if full_response.nil?
      nil
    else
      full_response["response"]["employers"][0]
    end

  end


  def get_ratings(response)
    { count: response["numberOfRatings"],
      overall: response["overallRating"],
      culture: response["cultureAndValuesRating"],
      leadership: response["seniorLeadershipRating"],
      compensation: response["compensationAndBenefitsRating"],
      opportunity: response["careerOpportunitiesRating"],
      balance: response["workLifeBalanceRating"],
    }
  end


  def featured_review(response)
    response["featuredReview"] || "n/a"
  end


end