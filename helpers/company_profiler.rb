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

  # makes API call, and filter results for a company with a name that
  # exactly matches our query
  def search(options = {})
    all_results = self.class.get(self.class.base_uri, options)

    exact_match(all_results, options[:query][:q])
  end

  # gets the featuredReview hash from the company result
  def featured_review(result)
    result["featuredReview"] unless result.nil?
  end

  # gets the ratings info that we're interested in from the company result
  def ratings(result)
    unless result.nil?
      {
        description:                  result["ratingDescription"],
        overall:                      result["overallRating"],
        culture_and_values:           result["cultureAndValuesRating"],
        senior_leadership:            result["seniorLeadershipRating"],
        compensation_and_benefits:    result["compensationAndBenefitsRating"],
        career_opportunities:         result["careerOpportunitiesRating"],
        work_life_balance:            result["workLifeBalanceRating"],
        recommend_to_friend:          result["recommendToFriendRating"]
      }
    end
  end

  private

  # loads my Glassdoor API partner ID and key from a YAML file
  def load_config
    YAML.load(File.read("#{File.dirname(__FILE__)}/company_profiler/company_profiler.yaml"))
  end

  # filter company search results to return only the entry that
  # exactly matches the company name we're looking for
  def exact_match(results, company)
    if results["success"] && results["status"] == "OK"
      results["response"]["employers"].select { |result| result["exactMatch"] }.first
    end
  end
end

if $0 == __FILE__
  query = { q: "Google", l: "Singapore"}
  profiler = CompanyProfiler.new

  result = profiler.search(query: query)

  pp result
  pp profiler.featured_review(result)
  pp profiler.ratings(result)
end
