require './hidden.rb'
require 'typhoeus'
require 'json'



class APIClient


  def initialize(base_uri, options={})
    @base_uri = base_uri
    @partner_id, @partner_key, @userip, @useragent, @format, @v, @action =
    options[:partner_id], options[:partner_key], options[:userip], options[:useragent],
    options[:format], options[:v], options[:action]
  end


  def company_rating(company)
    response = send_request(company)
    response_body = JSON.parse(response.body)
    if response_body["response"]["employers"].empty?
      co_ratings = no_info_returned(company)
    else
      co_ratings = parse_ratings(parse_employers(response_body, company))
    end
  end


private


  def parse_employers(employers_hash, company)
    if employers_hash["response"]["totalRecordCount"] > 1
      employers_hash["response"]["employers"].each do |hash|
        if hash["name"] == company
          employers_hash = hash
        end
      end
    else
      employers_hash = employers_hash["response"]["employers"][0]
    end
    employers_hash
  end


  def parse_ratings(employers_hash)
    ratings = {:overall => employers_hash["overallRating"],
               :culture_and_values => employers_hash["cultureAndValuesRating"],
               :compensation_and_benefits => employers_hash["compensationAndBenefitsRating"],
               :worklife_balance => employers_hash["workLifeBalanceRating"],
              }
    if employers_hash.has_key?("featuredReview")
      ratings[:featured_review_pros] = employers_hash["featuredReview"]["pros"]
      ratings[:featured_review_cons] = employers_hash["featuredReview"]["cons"]
    end
    ratings
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


  def no_info_returned(company)
    ratings = {:overall => "No Info Avail",
               :culture_and_values => "No Info Avail",
               :compensation_and_benefits => "No Info Avail",
               :worklife_balance => "No Info Avail",
               :featured_review_pros => "No Info Avail",
               :featured_review_cons => "No Info Avail"
              }
  end


end # end of class
