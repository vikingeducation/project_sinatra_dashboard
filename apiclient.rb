require './hidden.rb'
require 'typhoeus'
require 'httparty'
require 'json'

# http://api.glassdoor.com/api/api.htm?
# t.p=177857&t.k=c0AkCTQ8MX5&userip=72.174.9.5&
# useragent=chrome&format=json&v=1&action=employers&
# q=Crescent Solutions Inc


class APIClient

  def initialize(options={})
    @partner_id, @partner_key, @userip, @useragent, @format, @v, @action, @base_uri =
    options[:partner_id], options[:partner_key], options[:userip], options[:useragent],
    options[:format], options[:v], options[:action], options[:base_uri]
  end

  def company_rating(company="Crescent Solutions, Inc.")
    response = send_request(company)
    response_body = JSON.parse(response.body)
    # pp response_body
    if response_body["response"]["totalRecordCount"] > 1
      response_body["response"]["employers"].each do |hash|
        if hash["name"] == company
          response_body = hash
        end
      end
    else
      response_body = response_body["response"]["employers"]
    end
    puts "Overall Rating: #{response_body["overallRating"]}"
    puts "Culture And Values Rating: #{response_body["cultureAndValuesRating"]}"
    puts "Compensation And Benefits Rating: #{response_body["compensationAndBenefitsRating"]}"
    puts "Worklife Balance Rating: #{response_body["workLifeBalanceRating"]}"
    puts "Featured Reviews, Pros: #{response_body["featuredReview"]["pros"]}"
    puts "Featured Reviews, Cons: #{response_body["featuredReview"]["cons"]}"
  end



  def send_request(company)
    uri = (@base_uri + "?")
    params = { "t.p" => @partner_id,
               "t.k" => @partner_key,
               "userip" => @userip,
               "useragent" => @useragent,
               "format" => @format,
               "v" => @v,
               "action" => @action,
               "q" => company
             }
    request = Typhoeus::Request.new( uri,
                                     method: :get,
                                     params: params )
    request.run
    request.response
  end




end # end of class
