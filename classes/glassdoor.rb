
class CompanyProfiler
  attr_reader :user_ip, :user_agent

  def initialize( user_ip, user_agent )
    @user_ip = user_ip
    @user_agent = URI.escape(user_agent)
  end

  def get_comp_info(job)
    return {} if job.company.nil? || job.location.nil?

    results = search( job.company, job.location )

    if results["success"]
      parse_data(results)
    else
      {}
    end
  end

  def parse_data(results)
    {
      overall_rating: results['response']['employers'][0]['overallRating'],
      compensation_rating: results['response']['employers'][0]['compensationAndBenefitsRating'],
      industry: results['response']['employers'][0]['industryName'],
      pros: results['response']['employers'][0]['featuredReview']['pros'],
      cons: results['response']['employers'][0]['featuredReview']['cons']
    }
  end

  # outputs a hash of values
  def search(company_name, city)
    query = build_query(URI.escape(company_name), URI.escape(city))
    puts "Query"
    p query

    response = Net::HTTP.get("api.glassdoor.com", query)

    JSON.parse(response)
  end

  def build_query(company, city)
    query = "/api/api.htm?"
    query += "t.p=#{ENV['glassdoor_id']}&t.k=#{ENV['glassdoor_key']}"
    query += "&userip=#{user_ip}&useragent=#{user_agent}"
    query += "&format=json&v=1&action=employers"
    query += "&q=#{company}&l=#{city}"
  end
end
