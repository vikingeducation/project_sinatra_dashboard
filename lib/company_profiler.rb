
Figaro.application = Figaro::Application.new(
  environment: "development",
  path: "config/application.yml"
)
Figaro.load

class CompanyProfiler
  attr_accessor :uri
  
  API_KEY = Figaro.env.API_KEY
  PARTNER_ID = Figaro.env.PARTNER_ID
  BASE_URI  = "http://api.glassdoor.com/api/api.htm?"

  def initialize
  end

  def create_uri(company,location)
    @uri = "#{BASE_URI}"
    @uri << "v=1&format=json" # version and format
    @uri << "&t.p=#{PARTNER_ID}&t.k=#{API_KEY}" # secret codes
    @uri << "&action=employers&q=#{company}&l=#{location}" # search fields
    # @uri << "&userip=#{ip}&useragent=#{ua}" # ip and user agent
    binding.pry
  end

end
