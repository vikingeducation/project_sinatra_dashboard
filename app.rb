require 'sinatra'
require 'json'
require 'erb'
require 'csv'
require 'smarter_csv'
require './helpers/helper_methods.rb'
require './modules/scraper.rb'
require './modules/apiclient.rb'
require './modules/geo_ip.rb'
require './hidden.rb' # holds API partner key and id for glassdoor and PARAMETERS
require 'sinatra/reloader' if development?
require 'pry-byebug' if development?

enable :sessions

include HiddenInfo # holds API partner key and id for glassdoor and PARAMETERS

get '/' do
  erb :index
end

get '/start' do
  clear_sessions
  ip_client = GEOIP.new("#{request.ip}") # replace with "72.174.4.38" when testing
  session[:ip_location] = ip_client.location_info
  erb :search_form
end

post '/search' do
  search_options = determine_search_params
  session[:job_location] = search_options[:location]
  find_jobs(search_options)
  save_employer_ratings(find_company_info)
  erb :search_complete
end

get '/search' do
  @location = session[:job_location]
  @csv_table = CSV.open("all.csv", :headers => true).read
  erb :results
end
