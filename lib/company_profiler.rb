
Figaro.application = Figaro::Application.new(
  environment: "development",
  path: "config/application.yml"
)
Figaro.load

class CompanyProfiler

  API_KEY = Figaro.env.API_KEY
  PARTNER_ID = Figaro.env.PARTNER_ID
  BASE_URI  = "http://api.glassdoor.com/api/api.htm?"

  def initialize
    create_uri
  end

  def create_uri
    @uri = "#{BASE_URI}"
  end

end
  