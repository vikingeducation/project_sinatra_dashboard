require 'figaro'


class CompanyProfiler
  
  attr_accessor :uri

  Figaro.application = Figaro::Application.new(
    environment: "development",
    path: "config/application.yml"
  )
  Figaro.load

  API_KEY = Figaro.env.API_KEY
  PARTNER_ID = Figaro.env.PARTNER_ID
  BASE_URI  = "http://api.glassdoor.com/api/api.htm?"

  def initialize
    @profiles = []
  end

  def get_profiles(results)
    results.each do |result|
      company = result[2]
      location = result[3]
      retrieve_data(company,location)
    end
  end

  def retrieve_data(company,location)
    uri = "#{BASE_URI}"
    uri << "v=1&format=json" # version and format
    uri << "&t.p=#{PARTNER_ID}&t.k=#{API_KEY}" # secret codes
    uri << "&action=employers&q=#{company}&l=#{location}" # search fields
    uri << "&userip=108.185.219.255&useragent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36" # ip and user agent

    @profiles << HTTParty.get(uri)
    binding.pry
  end

end
