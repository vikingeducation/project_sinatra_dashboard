require 'sinatra'
require 'erb'
require 'mechanize'
require 'uri'
require 'thin'
require 'cgi'
require 'csv'
require './helpers/job_scraper'
require './helpers/get_locator'
require './helpers/company_reviews'
require 'httparty'
require 'envyable'
require 'pry'

enable :sessions

# get '/' do        
  # location input manually
# 	erb :index
# end

get '/' do         
  # binding.pry
  session.clear
  # client_ip = request.ip 
    # works when on the server for external user
  client_ip = "169.156.91.245" 
    # hence hard code used here (Baltimore, MD)
  location = Locator.new.get_locator(client_ip)
  session[:location] = location
  erb :index_locator_found_from_IP_address, locals: {location: location} 
# end
end

post '/index' do

  # binding.pry
	title_or_keyword = params[:title_or_keyword]
  session[:title_or_keyword] = title_or_keyword
	location = session[:location]
	# get job list from Dice.com dice.get_job_list (?)
  JobHunter.new.get_me_a_job(title_or_keyword, location)

  # open 'job_hunt_straight_to_results.csv' in results.erb, and print results there, result by result
	redirect '/results' 
end

get '/results' do
  results = []
	title_or_keyword = session[:title_or_keyword]
	location = session[:location]

  if File.exist?('job_hunt_straight_to_results.csv')
    CSV.foreach('job_hunt_straight_to_results.csv') do |row| 
       results << row
    end
  end

  locals = {
    :title_or_keyword => title_or_keyword,
   	:location => location,
   	:results => results
  }

  erb :results, :locals => locals
end
