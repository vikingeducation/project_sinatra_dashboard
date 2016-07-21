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
  erb :index, locals: { jobs: nil }
end

post '/scraper' do
  query = "CyberCoders" #params[:keyword]
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

get '/glassdoorapi/:name' do |n|
  query = "#{n}" #"#{:name}"
  profiler = CompanyProfileHelper::CompanyProfiler.new(request)
  results = profiler.get_all_info(query)
  binding.pry
  erb :company_profile, locals: { results: results }
end