require 'sinatra'
require 'json'
require 'erb'
require 'csv'
require './modules/scraper.rb'
require './helpers/helper_methods.rb'
require './modules/apiclient.rb'
require './modules/geo_ip.rb'
require './hidden.rb' # holds API partner key and id for glassdoor and PARAMETERS
require 'sinatra/reloader' if development?
require 'pry-byebug' if development?

enable :sessions

include APIHelpers

get '/' do
  ip_client = GEOIP.new("72.174.4.38")
  session[:ip_location] = ip_client.location_info
  erb :index
end

get '/start' do
  erb :search_form
end

post '/search' do
  search_options = determine_search_params
  find_jobs(search_options)
  find_company_info
  session[:job_location] = search_options[:location]
  erb :search_complete
end

get '/search' do
  @location = session[:job_location]
  combine_tables
  @csv_table = CSV.open("all.csv", :headers => true).read
  erb :results
end
