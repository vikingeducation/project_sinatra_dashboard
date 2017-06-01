require 'httparty'
require 'pp'

class CompanyProfiler
  include HTTParty

  base_uri 'http://api.glassdoor.com/api/api.htm'
  default_params v: '1',
                 format: 'json',
                 userip: '0.0.0.0',
                 useragent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
                 action: 'employers'

  # initializes an instance of CompanyProfiler with
  # my Glassdoor API partner ID and key
  def initialize
    config = load_config

    self.class.default_params :'t.p' => config["t.p"], :'t.k' => config["t.k"]
  end

  # hits Glassdoor API to search for company data
  def search(options = {})
    self.class.get(self.class.base_uri, options)
  end

  # filter company search results to return only the entry that
  # exactly matches the company name we're looking for
  def exact_match(results)
    if results["success"] && results["status"] == "OK"
      results["response"]["employers"].select { |result| result["exactMatch"] }.first
    end
  end

  # filter company search results to return all other entries
  # that are not exact matches for the company name we're looking for
  def all_other_matches(results)
    if results["success"] && results["status"] == "OK"
      results["response"]["employers"].select { |result| !result["exactMatch"] }
    end
  end

  # gets the featuredReview hash from the company result
  def featured_review(result)
    result["featuredReview"] unless result.nil?
  end

  # gets the ratings info that we're interested in from the company result
  def ratings(result)
    unless result.nil?
      {
        description:                 result["ratingDescription"],
        overall:                     result["overallRating"],
        culture_and_values:          result["cultureAndValuesRating"],
        senior_leadership:           result["seniorLeadershipRating"],
        compensation_and_benefits:   result["compensationAndBenefitsRating"],
        career_opportunities:        result["careerOpportunitiesRating"],
        work_life_balance:           result["workLifeBalanceRating"],
        recommend_to_friend:         result["recommendToFriendRating"]
      }
    end
  end

  # returns the company name from a search result
  def company(result)
    result["name"] unless result.nil?
  end

  private

  # loads my Glassdoor API partner ID and key from a YAML file
  def load_config
    YAML.load(File.read("#{File.dirname(__FILE__)}/config/company_profiler.yaml"))
  end
end

if $0 == __FILE__
  query = { q: "Amazon", l: "Singapore"}
  profiler = CompanyProfiler.new

  results = profiler.search(query: query)

  pp results
end
