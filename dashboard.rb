
require 'sinatra'
require 'sinatra/reloader' if development?
require './scraper.rb'
require './ip_geo_loc.rb'

get '/' do

  visitor_ip = self.class.development? ? "github.com" : request.ip 
  
  query = IPGeoLocation.new( visitor_ip )  
  visitor_info = query.ip_response

  scraper = DiceScraper.new( "c++", visitor_info["city"] )
  scraper.scrape
  job_array = CSV.read("dice_job.csv")

  companies = []
  job_array.each do |row|
    companies << row[2]
  end

  credentials = File.read("glassdoor_api.txt")
  result = credentials.split("\n")
  partner_id = result[0]

  glassdoor = GlassdoorCompanyQuery.new()
  key = result[1]

  erb :index, locals: { job_table: job_array}
end

post '/' do
  keywords = params[:keywords]
  location = params[:location]

  scraper = DiceScraper.new(keywords, location)
  scraper.scrape
  job_array = CSV.read("dice_job.csv")
  erb :index, locals: { job_table: job_array}
end
