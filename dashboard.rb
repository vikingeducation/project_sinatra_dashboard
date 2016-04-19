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

# How to use the development? to know assign fake ip if develop

get "/" do
  user_variables = find_ip
  save_ip( user_variables )
  erb :'index'
end

post "/" do
  search = params["search"].split(" ").join("_")
  # request.cookies["city"] ? ( city = request.cookies["city"].split(" ").join("_") ) : ( city = "New_york" )
  parser = Parser.new
  @city, @country_code = request.cookies["city"], request.cookies["country_code"]
  @results = parser.parsing_html( "https://www.dice.com/jobs/sort-date-q-#{search}-limit-30-l-#{@city}-radius-El-jobs.html?searchid=3223042923491" )
  
  @results.each do |job|

    if company = job.company

      company_info = CompanyProfiler.search( company, request )
      company_info = company_info["response"]["employers"][0]
      new_company = CompanyData.new( company_info["cultureAndValuesRating"], 
                                     company_info["compensationAndBenefitsRating"], 
                                     company_info["workLifeBalanceRating"])
      job.company_data = new_company
    end
  end

  erb :'index'
end
