require 'sinatra'
require 'json'
require 'erb'
require 'csv'
require './modules/scraper.rb'
require './helpers/helper_methods.rb'
require './modules/apiclient.rb'
require './modules/geo_ip.rb'
require './hidden.rb'
require 'sinatra/reloader' if development?
require 'pry-byebug' if development?

enable :sessions

include APIHelpers

get '/' do
  ip_client = GEOIP.new("72.174.4.38")
  location = ip_client.location_info
  session[:search_location] = location
  erb :index
end

get '/start' do
  erb :search_form
end

post '/search' do
  # pausing scraping during development
  location = session[:search_location]
  options = search_params
  options[:location] = location
  find_jobs(options)
  @client = APIClient.new(PARAMETERS)
  @csv_table = CSV.open("jobs.csv", :headers => true)
  @csv_table.each do |row|
    row.each do |element|
      if element[0] == "Company Name"
        @client.company_rating(element[1])
        sleep rand(0..3)
      end
    end
  end
  session[:search_location] = location
  erb :search_complete
end

get '/search' do
  @location = session[:search_location]
  @jobs_table = CSV.open("jobs.csv", :headers => true).read
  @ratings_table = CSV.open("ratings.csv", :headers => true).read
  @combined = @jobs_table.to_a.each_with_index.map {|row, index| row.to_a.concat(@ratings_table.to_a[index]) }
  CSV.open('all.csv', "a+") do |row|
    @combined.each do |line|
      row << line
    end
  end
  @csv_table = CSV.open("all.csv", :headers => true).read
  erb :results
end
