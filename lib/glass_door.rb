class GlassDoor
  include HTTParty

  KEY = ENV['glassdoor_key']
  ID = ENV['glassdoor_id']
  base_uri 'http://api.glassdoor.com/api/api.htm'

  def self.for_company(company_name, ip_address, user_agent)
    options = {
      'v' => 1,
      'format' => 'json',
      't.p' => ID,
      't.k' => KEY,
      'userip' => ip_address,
      'useragent' => user_agent,
      'action' => 'employers',
      'q' => company_name.scan(/[\w\d ]+/).join
    }
    response = get("", { query: options } )
    company_json = response['response']['employers'][0]
    return false unless company_json
    Company.from_json(company_json)
  end
end

class Company
  attr_accessor :name, :website, :num_ratings, :rating, :review

  def self.from_json(json)
    company = new
    company.name = json['name']
    company.website = json['website']
    company.num_ratings = json['numberOfRatings']
    company.rating = json['overallRating']
    company.review = Review.from_json(json['featuredReview']) if json['featuredReview']
    company
  end
end

class Review
  attr_accessor :job_title, :rating, :pros, :cons

  def self.from_json(json)
    review = new
    review.job_title = json['jobTitle']
    review.rating = json['overall']
    review.pros = json['pros']
    review.cons = json['cons']
    review
  end
end
