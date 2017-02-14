require 'erb'
require 'pry-byebug'
require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/helper.rb'
require 'json'
require 'rubygems'
require 'mechanize'


helpers JobHuntHelper

enable :sessions
set :session_secret, '*&(^B234'

get "/" do
  jobs = all_jobs("Galway", "ruby", "", "")
  erb :index, locals: {jobs: jobs}
end

post "/search_refine" do
  binding.pry
  city = params[:city]
  keyword = params[:keyword]
  company = params[:company]
  date = params[:adv_date]
  jobs = all_jobs(city, keyword, company, date)
  erb :index, locals: {jobs: jobs}
  # redirect to("/search_results")
end

# get "/search_results" do

# end

