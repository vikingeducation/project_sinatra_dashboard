require 'httparty'
require 'json'


require 'pp'
require_relative '../figaro_file'

module CompanyProfiler

  BASE_URI = "http://api.glassdoor.com/api/api.htm?v=1&format=json"
  PID = ENV['GLASS_ID']
  KEY = ENV['GLASS_KEY']
  Profile = Struct.new(:overall, :culture, :compensation)

  def self.get_profile(c_name)
    glassdoor_data = get_glassdoor_data(c_name)
    create_company_profile(glassdoor_data)
  end

  private

    def self.create_company_profile(company_info)
      profile = Profile.new
      profile.overall = overall_rating(company_info)
      profile.culture = culture_rating(company_info)
      profile.compensation = compensation_rating(company_info)
      profile
    end

    def self.overall_rating(company_info)
      company_info["response"]["employers"][0]["overallRating"]
    end

    def self.culture_rating(company_info)
      company_info["response"]["employers"][0]["cultureAndValuesRating"]
    end

    def self.compensation_rating(company_info)
      company_info["response"]["employers"][0]["compensationAndBenefitsRating"]
    end

    def self.get_glassdoor_data(c_name)
      # unknown rate limit
      sleep(0.75)
      api_response = HTTParty.get("#{ BASE_URI }&t.p=#{ PID }&t.k=#{KEY}&action=employers&q=#{ c_name }").body
      parse_glassdoor_api(api_response)
    end

    def self.parse_glassdoor_api(json)
      JSON.parse(json)
    end
end

p CompanyProfiler.get_profile("Google")
