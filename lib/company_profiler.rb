# uses glassdoor api to query company data

require 'httparty'

class CompanyProfiler
  def initialize(id, key, ip)
    @id = id
    @key = key
    @ip = ip
  end

  def get_info(query)
    base_uri = "http://api.glassdoor.com/api/api.htm"
    q = query
    uri = "#{base_uri}?t.p=#{@id}&t.k=#{@key}&userip=#{@ip}&useragent=Mozilla/%2F4.0&format=json&v=1&action=employers&q=#{q}"
    info = HTTParty.get(uri)
  end
end

#'http://api.glassdoor.com/api/api.htm?t.p=44526&t.k=iLqhfsy2zw7&userip=208.98.229.39&useragent=Mozilla/%2F4.0&format=json&v=1&action=employers&q=219213'