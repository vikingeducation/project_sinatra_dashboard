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
  session[:ip_location] = (ip_client.location_info)
  erb :index
end

get '/start' do
  erb :search_form
end

post '/search' do
  location = session[:ip_location]
  options = search_params
  if options[:location].nil?
    options[:location] = location
  end
  find_jobs(options)
  @client = APIClient.new(PARAMETERS)
  @job_table = CSV.open("jobs.csv", :headers => true)
  @job_table.each do |row|
    row.each do |element|
      if element[0] == "Company Name"
        @client.company_rating(element[1])
        sleep rand(0..3)
      end
    end
  end
  session[:jobs_table] = @csv_table
  session[:ip_location] = location
  erb :search_complete
end

get '/search' do
  @location = session[:ip_location]
  @job_table = session[:jobs_table]
  @ratings_table = CSV.open("ratings.csv", :headers => true).read
  @combined = @job_table.to_a.each_with_index.map {|row, index| row.to_a.concat(@ratings_table.to_a[index]) }
  CSV.open('all.csv', "a+") do |row|
    @combined.each do |line|
      row << line
    end
  end
  @csv_table = CSV.open("all.csv", :headers => true).read
  erb :results
end
