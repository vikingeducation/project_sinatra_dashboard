# GET "/"
# Find Ip
#   if local ip, put hard-coded one
# Check Api Locator to find the city
# Save city, and Country
#
# Find User_Agent
# Save User_Agent

# POST "/"
# Take The Search Param
# New Parser With Search param and City
#
# For Each Job Post
#   Check the company
#   Check if we already looks the company
#   Create a new Struct with the information

# Save In session :
#   Ip, and User_agent
#   The city, Country_code
#   The Jobs results


require 'sinatra'
require 'sinatra/reloader' if development?
require './web_scraper/parser'
require 'rubygems'
require 'pry-byebug'
require 'bundler/setup'
require 'mechanize'
require 'httparty'
require './lib/company'
require './helpers/search_helper'
require './helpers/save_helper'

helpers SearchHelper, SaveHelper

enable :sessions

# How to use the development? to know assign fake ip if develop

get "/" do
  if session[:ip].nil?
    user = find_information
    save_ip( user )
  end
  erb :'index', locals: { city: session[:city], 
                          country_code: session[:country_code] }
end

post "/" do
  search = params["search"].gsub!(" ", "_")
  parser = Parser.new
  results = parser.parsing_html( "https://www.dice.com/jobs/sort-date-q-#{search}-limit-30-l-#{session[:city]}-radius-El-jobs.html?searchid=3223042923491" )
  
  @results = get_company_info( results )
  erb :'index', locals: { city: session[:city], 
                          country_code: session[:country_code] }
end










