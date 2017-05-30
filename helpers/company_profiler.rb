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

  # searches for company data
  def search(options = {})
    self.class.get(self.class.base_uri, options)
  end

  # filter company search results to return only the entries that
  # exactly match the company name we're looking for
  def filter_results(results, company)
    if results["success"] && results["status"] == "OK"
      results["response"]["employers"].select { |result| result["name"].match(/#{company}/i) }.first
    end
  end

  # gets the featuredReview hash from the company result
  def featured_review(result)
    result["featuredReview"] unless result.nil?
  end

  private

  # loads my Glassdoor API partner ID and key from a YAML file
  def load_config
    YAML.load(File.read("#{File.dirname(__FILE__)}/company_profiler/company_profiler.yaml"))
  end
end

if $0 == __FILE__
  query = { q: "Google", l: "Singapore"}
  profiler = CompanyProfiler.new

  results = profiler.search(query: query)
  result = profiler.filter_results(results, "Google")

  pp result
  pp profiler.featured_review(result)
end
