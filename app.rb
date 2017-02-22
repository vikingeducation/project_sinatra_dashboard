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
  ip_locator = GPSLocator.new(request.ip)
  city = session[:city] || ip_locator.get_raw_response["city"]
  # city = session[:city] || "Galway"
  keyword = session[:keyword] || "ruby"
  company = session[:company] || ""
  date = session[:date] || ""
  session[:city] = city
  jobs = all_jobs(city, keyword, company, date, ip_locator)
  erb :index, locals: {jobs: jobs}
end

post "/search_refine" do
  session.clear
  params[:city].nil? ? city = session[:city] : city = params[:city]
  keyword = params[:keyword]
  company = params[:company]
  date = params[:adv_date]
  session[:keyword] = keyword
  session[:company] = company
  session[:date] = date
  session[:city] = city
  redirect to "/"
end

# get "/clear_session" do
#   session.clear
#   redirect to "/"
# end

