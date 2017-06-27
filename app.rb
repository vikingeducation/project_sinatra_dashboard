# Web scraper with Sinatra
require "sinatra"
require "sinatra/reloader" if development?
require "./models/job_scraper.rb"
require "./models/locator.rb"
require "./helpers/geo_location_helper.rb"
require 'dotenv/load' 

helpers GeoLocationHelper

enable :sessions


get '/' do
  # For each new search, clear any active sessions
  # session.clear 
  
  PARTNER_ID = ENV["PARTNER_ID"]
  API_KEY = ENV["API_KEY"]

  ip_addr = get_id

  puts "The ip address #{ip_addr}"
  locator = Locator.new
  ip_details = locator.get_location(ip_addr)

  puts "#{ip_details}"
  puts "#{get_city(ip_details)}"
  session[:city] = get_city(ip_details)
  session[:country] = get_country(ip_details)
  session[:partner_id] = PARTNER_ID
  session[:api_key] = API_KEY


  puts "The partner id is #{PARTNER_ID}"
  puts "The api key is #{API_KEY}"

  erb :index
end


post '/search' do
  search_term = params[:search_terms]
  location = params[:location]
  radius = params[:radius]
  city = session[:city]
  country = session[:country]
  partner_id = session[:partner_id]
  api_key = session[:api_key]

  puts "The partner id is #{partner_id}"
  puts "The api key is #{api_key}"

  job_scraper = JobScraper.new

  job_scraper.create_search(search_term, location, radius)
  job_scraper.extract_job_details
  job_scraper.csv_file.create_file(job_scraper.results)
  job_scraper.get_company_ratings(partner_id, api_key)
  postings = job_scraper.results

    locals = {
    city: city,
    country: country,
    postings: postings
  }

  erb :index, :locals => locals
end