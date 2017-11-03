require 'dotenv/load'
require 'httparty'
require 'json'
require 'pry'

require_relative 'company'

class CompanyProfiler
  SAMPLE = 'http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120&t.k=fz6JLNDfgVs&action=employers&q=pharmaceuticals&userip=192.168.43.42&useragent=Mozilla/%2F4.0'

  BASE_URI = 'http://api.glassdoor.com/api/api.htm'
  VERSION = '1'
  FORMAT = 'json'
  PARTNER_ID = ENV['partner_id']
  PARTNER_KEY = ENV['api_key']
  ACTION = 'employers'

  def initialize(user_ip, user_agent)
    @user_ip = user_ip
    @user_agent = user_agent
  end

  def send_request(name, location)
    url = "#{BASE_URI}?t.p=#{PARTNER_ID}&t.k=#{PARTNER_KEY}&userip={@user_ip}&useragent=#{@user_agent}&format=#{FORMAT}&v=#{VERSION}&action=#{ACTION}&l=#{location}&q=#{name}"

    raw_response = HTTParty.get(url)
    response = raw_response.parsed_response['response']
    company = Company.new(location, response)
    company
  end

end