require 'erb'
require 'pry-byebug'
require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/helper.rb'
require './helpers/locator.rb'
require './helpers/company_profiler.rb'
require 'json'
require 'rubygems'
require 'mechanize'


helpers JobHuntHelper

enable :sessions
set :session_secret, '*&(^B234'

get "/" do
  # binding.pry
  ip_locator = GPSLocator.new(request.ip)
  #city = ip_locator.get_raw_response["city"]
  city = "Galway"
  # profiler = CompanyProfiler.new("Accenture", ip_locator)
  # test_glass = profiler.get_raw_response
  keyword = session[:keyword] || ''
  company = session[:company] || ''
  date = session[:adv_date] || ""
  session[:city] = city
  # session[:keyword] = keyword
  # session[:company] = company
  # session[:adv_date] = date
  jobs = all_jobs(city, keyword, company, date, ip_locator)
  erb :index, locals: {jobs: jobs, city: city}
end

post "/search_refine" do
  params[:city].nil? ? city = session[:city] : city = params[:city]
  keyword = params[:keyword]
  company = params[:company]
  date = params[:adv_date]
  jobs = all_jobs(city, keyword, company, date)
  session[:jobs] = jobs
  erb :index, locals: {jobs: jobs}
  # redirect to("/search")
end

# get "/search_results" do

# end

