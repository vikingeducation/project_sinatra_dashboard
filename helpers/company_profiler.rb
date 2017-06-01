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

  # grabs the company data we need from the search results
  # that we got from hitting the Glassdoor API
  def build_company_data(results)
    company_data = []

    if results["success"] && results["status"] == "OK"
      employers = results["response"]["employers"]
      employers.each do |employer|
        hash = {}
        hash[:employer] = employer["name"]
        hash[:ratings] = ratings(employer)
        hash[:featured_review] = featured_review(employer)
        hash[:exact_match] = employer["exactMatch"]

        company_data << hash
      end

      company_data.length > 0 ? company_data : nil
    end
  end

  # gets the featuredReview hash for the employer
  def featured_review(employer)
    employer["featuredReview"] unless employer.nil?
  end

  # gets the ratings info we're interested in for the employer
  def ratings(employer)
    unless employer.nil?
      {
        description:                employer["ratingDescription"],
        overall:                    employer["overallRating"],
        culture_and_values:         employer["cultureAndValuesRating"],
        senior_leadership:          employer["seniorLeadershipRating"],
        compensation_and_benefits:  employer["compensationAndBenefitsRating"],
        career_opportunities:       employer["careerOpportunitiesRating"],
        work_life_balance:          employer["workLifeBalanceRating"],
        recommend_to_friend:        employer["recommendToFriendRating"]
      }
    end
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

  # pp results
  pp profiler.build_company_data(results)
end
