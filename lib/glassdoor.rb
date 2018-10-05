require 'httparty'

class GlassDoor
  include HTTParty

  attr_reader :response, :rating

  def initialize(company)
    @url = "http://api.glassdoor.com/api/api.htm?v=1&format=json&t.p=#{ENV["GLASSDOOR_ID"]}&t.k=#{ENV["GLASSDOOR_KEY"]}&action=employers&q=#{company}&userip=39.113.23.38&useragent=Mozilla/%2F5.0"
    @response = self.class.get(@url)
    @rating = "Unknown"
  end

  def get_rating
    unless @response["response"]["employers"].empty?
      @rating = @response["response"]["employers"][0]["overallRating"].to_s
    end
    @rating
  end

end
