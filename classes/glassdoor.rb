require 'figaro'

Figaro.application = Figaro::Application.new(
  path: File.expand_path("../../config/application.yml", __FILE__)
  )
Figaro.load

glassdoor_id = ENV['glassdoor_id']
glassdoor_key = ENV['glassdoor_key']

class CompanyProfiler
  def initialize
  end
  def search(company_name, city)
    # takes a company_name and city
    # outputs a hash of values

  end
  def build_query

  end
end
