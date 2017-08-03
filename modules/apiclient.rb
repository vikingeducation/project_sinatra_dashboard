require './hidden.rb'
require 'typhoeus'
require 'httparty'
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
      no_company_info_save
    else
      employer_rating_hash = parse_employers(response_body, company)
      co_ratings = parse_ratings(employer_rating_hash)
      save_ratings(co_ratings)
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


  def no_company_info_save
    headers = ["Overall Rating", "Culture and Values Rating", "Comp. and Bene Ratings", "Worklife Balance", "Pros", "Cons"]
    CSV.open('ratings.csv', 'a+', :headers => true) do |csv|
      csv << headers if csv.count.eql? 0
      csv << ["No Info available for this employer"]
    end
  end


  def save_ratings(ratings)
    headers = ["Overall Rating", "Culture and Values Rating", "Comp. and Bene Rating", "Worklife Balance", "Pros", "Cons"]
    CSV.open('ratings.csv', 'a+', :headers => true) do |csv|
      csv << headers if csv.count.eql? 0
      csv << ratings.values
    end
  end



end # end of class
