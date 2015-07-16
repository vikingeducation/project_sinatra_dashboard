require 'httparty'
require 'pry'

class CompanyProfiler

  keys = File.readlines("keys.txt")
  @@partner_id = keys[0].strip
  @@partner_key = keys[1].strip

  include HTTParty

  def initialize

    @options = { :query => { v: "1", format: "json", "t.p" => "#{@@partner_id}", "t.k" => "#{@@partner_key}", useragent: "Chrome", action: "employers", q: "pharmaceuticals"} }

  end

  def get_response

    HTTParty.get('http://api.glassdoor.com/api/api.htm?', @options)

  end

  # def extract_info

  #   response = get_response

  #   binding.pry

  # end


end