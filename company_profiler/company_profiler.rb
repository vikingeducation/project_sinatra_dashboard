require 'httparty'
require 'json'

module CompanyProfiler

  BASE_URI = "http://api.glassdoor.com/api/api.htm?v=1&format=json"
  PID = ENV['GLASS_ID']
  KEY = ENV['GLASS_KEY']

  def self.get_profile(c_name)

  end



  def self.culture_rating()
    #
  end

  def self.values_rating()
    #
  end

  def self.compensation_rating
    #
  end

  def self.benefits_rating
    #
  end

  private
  
  def self.get_json(c_name)
    HTTParty.get("#{BASE_URI}&t.p=#{PID}&t.k=#{KEY}&action=employers&q=#{c_name}")
  end

end


    # HTTParty.get("#{BASE_URI}&t.p=#{PID}&t.k=#{KEY}&action=employers&q=#{c_name}&userip=192.168.43.42&useragent=Mozilla/%2F4.0")