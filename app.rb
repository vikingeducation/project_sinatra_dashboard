require 'sinatra'
require 'erb'
require './helpers/script.rb'
require './helpers/view_helpers.rb'
require './helpers/locator.rb'
require './helpers/company_profiler.rb'

enable :sessions

helpers ScraperHelper
helpers ViewHelpers
helpers LocatorHelper
helpers CompanyProfileHelper

get '/' do
  # unless session["loc-data"]
  #   locator = LocatorHelper::Locator.new
  #   if development?
  #     locator.ip_address = "67.169.24.228"
  #   else
  #     locator.get_user_address(request)
  #   end
  #   loc_data = locator.get_location
  #   response.set_session("loc_data",loc_data)
  # end
  erb :index, locals: { jobs: nil }
end

post '/scraper' do
  query = params[:keyword]
  loc_data = session["loc-data"]
  location = nil
  if params[:location]
    location = params[:location]
  else
    location = loc_data["zip_code"]
  end
  scraper = ScraperHelper::DiceScraper.new(query, location)
  jobs = scraper.run

  erb :index, locals: { jobs: jobs }
end

get '/glassdoorapi' do
  query = "CyberCoders"#params[:keyword]
  profiler = CompanyProfileHelper::CompanyProfiler.new(request)
  profiler.build_url(query)
  results = profiler.get_request
  binding.pry
  #erb :glassdoorapi, locals: { results: results }
end