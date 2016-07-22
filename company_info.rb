require 'csv'
require 'httparty'

class CompanyInfo

  def self.get_company_name
    col_data = []

    CSV.foreach("csv_file.csv") do |row|
      col_data << row[1]
    end
    col_data
  end

  def self.get_company_data
    company_info = get_company_name

    company_info.map do |company|
      uri_name = URI.encode(company)
      HTTParty.get("http://api.glassdoor.com/api/api.htm?t.p=80602&t.k=gYfLHpPZ7ua&userip=96.60.200.208&useragent=mozilla/%2f4.0&format=json&v=1&action=employers&q=#{uri_name}")
    end
  end

  def self.parse_company_data
    company_data = get_company_data
    company_data.map do |company|
      [
        company['response']['employers'][0]['featuredReview']['pros'],
        company['response']['employers'][0]['featuredReview']['cons'],
        company['response']['employers'][0]['overallRating']
      ]

    end
  end

end

# puts CompanyInfo.get_company_name
# puts CompanyInfo.get_company_data
puts CompanyInfo.parse_company_data

