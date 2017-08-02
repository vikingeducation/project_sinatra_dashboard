require 'sinatra'
require 'json'
require 'erb'
require 'csv'
require './modules/scraper.rb'
require './helpers/helper_methods.rb'
require './apiclient.rb'
require './hidden.rb'
require 'sinatra/reloader' if development?
require 'pry-byebug' if development?

enable :sessions

include APIHelpers

get '/' do
  erb :index
end

get '/start' do
  erb :search_form
end

post '/search' do
  # pausing scraping during development
  # options = search_params
  # find_jobs(options)
  @client = APIClient.new(PARAMETERS)
  puts "--------------------------"
  puts "#{@client}"
  @csv_table = CSV.open("jobs.csv", :headers => true)
  @csv_table.each do |row|
    row.each do |element|
      puts "ELEMENT: #{element}"
      if element[0] == "Company Name"
        @client.company_rating(element[1])
      end
    end
  end
  erb :search_complete
end

get '/search' do
  @csv_table = CSV.open("jobs.csv", :headers => true).read
  erb :results
end
