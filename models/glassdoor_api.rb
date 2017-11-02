require 'dotenv/load'
require 'httparty'
require 'pp'
require 'json'
require 'date'
require 'pry'

class GlassdoorAPI
  SAMPLE = 'http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=120&t.k=fz6JLNDfgVs&action=employers&q=pharmaceuticals&userip=192.168.43.42&useragent=Mozilla/%2F4.0'

  BASE_URI = 'http://api.glassdoor.com/api/api.htm'
  VERSION = '1.1'
  FORMAT = 'json'
  PARTNER_ID = ENV['partner_id']
  PARTNER_KEY = ENV['api_key']
  ACTION = 'employers'

  def initialize(user_ip, user_agent)
    @user_ip = user_ip
    @user_agent = user_agent
  end

  def send_request
    # url = '#{BASE_URI}?v=#{VERSION}&format=#{FORMAT}&t.p=#{PARTNER_ID}&t.k=#{PARTNER_KEY}&action=#{ACTION}&q=pharmaceuticals&userip=#{user_ip}&useragent=#{user_agent}/%2F4.0'

    url = "#{BASE_URI}?t.p=#{PARTNER_ID}&t.k=#{PARTNER_KEY}&userip={@user_ip}&useragent=#{@user_agent}&format=#{FORMAT}&v=#{VERSION}&action=#{ACTION}"

    response = HTTParty.get(url)
    binding.pry
    results = JSON.parse(response)
  end

end