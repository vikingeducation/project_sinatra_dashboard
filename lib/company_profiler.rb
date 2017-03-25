require "mechanize"
require "json"

class CompanyProfiler
  attr_accessor :agent

  BASE_URI = "http://api.glassdoor.com/api/api.htm?"
  API_ID = ENV["API_ID"]
  API_KEY = ENV["API_KEY"]

  def initialize
    @agent = Mechanize.new
  end

  def sanitize_company_name(c)
    c.gsub(/\s/, "+")
  end

  def profile(opts)
    url = BASE_URI + [
      "v=1",
      "format=json",
      "t.p=#{opts[:id] || API_ID}",
      "t.k=#{opts[:key] || API_KEY}",
      "action=employers",
      "q=#{sanitize_company_name(opts[:company])}",
      "userip=#{opts[:ip]}",
      "useragent=Mozilla/%2F4.0"
    ].join("&")
    page = agent.get(url)
    JSON.parse(page.body)
  end

end
