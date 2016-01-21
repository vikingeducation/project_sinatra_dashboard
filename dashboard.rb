
require 'sinatra'
require 'sinatra/reloader' if development?
require './scraper.rb'
require './ip_geo_loc.rb'
require './company_profiler.rb'

get '/' do

  visitor_ip = self.class.development? ? "github.com" : request.ip

  query = IPGeoLocation.new( visitor_ip )
  visitor_info = query.ip_response

  scraper = DiceScraper.new( "c++", visitor_info["city"] )
  scraper.scrape
  job_array = CSV.read("dice_job.csv")

  # companies = []
  # job_array.each do |row|
  #   companies << row[2]
  # end
  #
  # companies.uniq!
  #
  # credentials = File.read("glassdoor_api.txt")
  # result = credentials.split("\n")
  # partner_id = result[0]
  # api_key = result[1]
  #
  # companies.each do |company|
  #   query = CompanyProfiler.new( partner_id, api_key, company )
  #   query.make_request
  #   company_ratings = [company, query.parse_response]
  # end

  erb :index, locals: { job_table: job_array }
  #erb :index, locals: { job_table: job_array, company_ratings: company_ratings}
end

post '/' do
  keywords = params[:keywords]
  location = params[:location]

  scraper = DiceScraper.new(keywords, location)
  scraper.scrape
  job_array = CSV.read("dice_job.csv")
  erb :index, locals: { job_table: job_array}
end
