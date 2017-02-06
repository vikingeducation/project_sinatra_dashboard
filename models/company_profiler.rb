class CompanyProfiler
  attr_reader :ratings
  def initialize(listings, ip)
    @listings = listings
    @ip = ip
    @ratings = []
  end

  def get_company_ratings
    get_companies
    get_ratings
  end

  def get_companies
    @companies = []
    @listings.each do |listing|
      unless @companies.include?(listing.company)
        @companies << listing.company unless listing.company == 'Confidential Company'
      end
    end
  end

  def get_ratings
    @companies.each do |company|
      response = HTTParty.get("http://api.glassdoor.com/api/api.htm?t.p=#{ENV['GD_id']}&t.k=#{ENV['GD_key']}&userip=#{@ip}&useragent=Mozilla/%2F5.0&format=json&v=1&action=employers&q=#{company}")
      unless response['response']['employers'].empty?
        @ratings << parse_response(response, company) if parse_response(response, company)
      end
      sleep 1
    end
  end

  def parse_response(response, company)
    response = response['response']['employers']
    response.each do |r|
      if company.include?(r['name'])
        return Rating.new(company, r['overallRating'], r['cultureAndValuesRating'], r['compensationAndBenefitsRating'], featured_summary(r), featured_url(r)
                          )
      end
    end
    nil
  end

  def featured_summary(response)
    if f = response['featuredReview']
      return response['featuredReview']['attributionURL']
    end
    ''
  end

  def featured_url(response)
    return response['featuredReview']['attributionURL'] if response['featuredReview']
    ''
  end

end
