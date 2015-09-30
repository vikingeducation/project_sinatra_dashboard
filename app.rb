require 'sinatra'
require 'json'
require 'pry-byebug'
require_relative 'lib/scraper.rb'
require_relative 'lib/locator.rb'
require_relative 'lib/company_profiler.rb'

enable :sessions

#environment variables for glassdoor
gd_id = 44526#ENV["GLASSDOOR_ID"]
gd_key = "iLqhfsy2zw7"#ENV["GLASSDOOR_KEY"]

get '/' do
  #get location of client (hit api only once per session)
  if session["location"].nil?
    locator = Locator.new
    #ip = request.ip
    ip = '208.98.229.39'
    session["ip"] = ip
    location = locator.get_location(ip)
    session["location"] = location.to_json 
  end
  loc = JSON.parse(session["location"])
  city = loc["city"]
  country = loc["country"]

  locals = {:city => city,
            :country => country}
  erb :'shared/form', :locals => locals
  #redirect to('/scraper')
end

post '/scrape' do
  uri = 'http://dice.com'
  query = params[:query]
  location = params[:location]

  scraper = Scraper.new
  scraper.scrape(uri,query,location)
  results = scraper.results

  locals = {:results => results}
  erb :index, :locals => locals
end

get '/company/:name' do
  company_name = params[:name]
  profiler = CompanyProfiler.new(gd_id, gd_key, session["ip"])
  results = profiler.get_info(company_name)

  #binding.pry

  if results.nil?
    companies = {"NO RESULTS" => ""}
  else
    companies = results["response"]["employers"]
  end

  locals = {:companies => companies}
  erb :company, :locals => locals
end

get '/scraper' do
  #erb :index
end