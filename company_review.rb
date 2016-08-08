# http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=84632&t.k=fQ8QKWEsfxG&action=employers&q=nokia&userip=192.168.43.42&useragent=Chrome
require 'pry'
require 'httparty'
class CompanyReview

  # Including their module so we have access to
  # their helper methods
  include HTTParty

  # This is a convenience method for
  # HTTParty::ClassMethods.base_uri
  base_uri 'http://api.glassdoor.com'

  # Actually run the request using their `get` convenience method
  def get(company_name)
    @options = { :query => { v: "1", format: "json",
                             userip: "192.168.43.42", useragent: "Chrome",
                             action: "employers",
                             "t.p".to_sym => "84632",
                             "t.k".to_sym => "fQ8QKWEsfxG" } }
    @options[:query][:q] = company_name
    response = self.class.get("/api/api.htm", @options)
    trim_response(response)
  end

  private:
  def trim_response(response)
    if response["success"] == true && response["status"] == "OK"
      op = response["response"]["employers"].first
      name = op["name"]
      hash = {}
      hash[name] = op
      hash
    end
  end
end

# p company_review = CompanyReview.new.get("nokia")
