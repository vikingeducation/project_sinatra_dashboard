require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "json"
require "mechanize"
require "httparty"
require_relative "job_scraper"
require_relative "locator"
require_relative "company_profiler"
require_relative "./helpers/ratings_helper"
  
set :server, "webrick"
enable :sessions

helpers RatingsHelper

get "/" do 
  erb :welcome
end

post "/job_listings" do   
  @current_location = Locator.new.current_location
  search_term = params["keywords"]
  @location = params["location"]
  @city = @location.match(/(.*),/)[1].split.map { |word| word.capitalize }.join(" ")
  @location.empty? ? scraper = JobScraper.new(search_term, @current_location) :
    scraper = JobScraper.new(search_term, @location) 
  @jobs_data = scraper.job_details
  append_ratings(@jobs_data)
  @column_names = ["Job Title", "Company", "Job Link", "Location", "Date", "Overall", "Culture", "Compensation", "Work/Life"]
  erb :job_listings
end

get "/job_listings" do 
  redirect to("/")
end

