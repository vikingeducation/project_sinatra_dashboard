require 'figaro'

Figaro.application = Figaro::Application.new(
  path: File.expand_path("../../config/application.yml", __FILE__)
  )
Figaro.load

glassdoor_id = ENV['glassdoor_id']
glassdoor_key = ENV['glassdoor_key']

# http://api.glassdoor.com/api/api.htm?t.p=5317&
# t.k=n07aR34Lk3Y&userip=0.0.0.0&useragent=&format=json&v=1&action=employers

class CompanyProfiler
  attr_reader :user_ip, :user_agent

  def initialize( user_ip, user_agent )
    p @user_ip = user_ip
    p @user_agent = user_agent
  end

  def get_comp_info(job)
    return {} if job[:company].nil? || job[:location].nil?

    search( job[:company], job[:location])
  end

  # outputs a hash of values
  def search(company_name, city)
    query = build_query(company_name, city)
    p query
  end

  def build_query(company, city)
    query = "http://api.glassdoor.com/api/api.htm?"
    query += "t.p=#{glassdoor_id}&t.k=#{glassdoor_key}"
    query += "&userip=#{user_ip}&useragent=#{user_agent}"
    query += "&format=json&v=1&action=employers"
    query += "&q=#{company}&l=#{city}"
  end
end
