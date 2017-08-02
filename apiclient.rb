require './hidden.rb'
require 'typhoeus'
require 'httparty'
require 'json'



class APIClient

  def initialize(options={})
    @partner_id, @partner_key, @userip, @useragent, @format, @v, @action, @base_uri =
    options[:partner_id], options[:partner_key], options[:userip], options[:useragent],
    options[:format], options[:v], options[:action], options[:base_uri]
  end


  def company_rating(company="Crescent Solutions, Inc.")
    response = send_request(company)
    response_body = JSON.parse(response.body)
    pp response_body

    if response_body["response"]["employers"].empty?
      headers = ["Overall Rating", "Culture and Values Rating", "Comp. and Bene Ratings", "Worklife Balance", "Pros", "Cons"]
      CSV.open('ratings.csv', 'a+', :headers => true) do |csv|
        csv << headers if csv.count.eql? 0
        csv << ["No Info available for this employer"]
      end
    else
      if response_body["response"]["totalRecordCount"] > 1
        response_body["response"]["employers"].each do |hash|
          if hash["name"] == company
            response_body = hash
          end
        end
      else
        response_body = response_body["response"]["employers"][0]
      end

      ratings = {:overall => response_body["overallRating"],
                 :culture_and_values => response_body["cultureAndValuesRating"],
                 :compensation_and_benefits => response_body["compensationAndBenefitsRating"],
                 :worklife_balance => response_body["workLifeBalanceRating"],
                }

      if response_body.has_key?("featuredReview")
        ratings[:featured_review_pros] = response_body["featuredReview"]["pros"]
        ratings[:featured_review_cons] = response_body["featuredReview"]["cons"]
        # puts "Featured Reviews, Pros: #{response_body["featuredReview"]["pros"]}"
        # puts "Featured Reviews, Cons: #{response_body["featuredReview"]["cons"]}"
      end
      # puts "Overall Rating: #{response_body["overallRating"]}"
      # puts "Culture And Values Rating: #{response_body["cultureAndValuesRating"]}"
      # puts "Compensation And Benefits Rating: #{response_body["compensationAndBenefitsRating"]}"
      # puts "Worklife Balance Rating: #{response_body["workLifeBalanceRating"]}"
      headers = ["Overall Rating", "Culture and Values Rating", "Comp. and Bene Rating", "Worklife Balance", "Pros", "Cons"]
      CSV.open('ratings.csv', 'a+', :headers => true) do |csv|
        csv << headers if csv.count.eql? 0
        csv << ratings.values
      end
    end
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
