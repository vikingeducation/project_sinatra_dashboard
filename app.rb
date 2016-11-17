#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require 'figaro'
require_relative './figaro_file'
require_relative 'helpers/dice_scraper_helper'
require_relative 'helpers/locator_helper'
require_relative 'test_results'
require_relative 'classes/glassdoor'

enable :sessions

helpers DiceScraperHelper, LocatorHelper

get '/' do
  session[:location] ||= get_IP_location(request.ip)
  erb :index
end

# TODO: Glassdoor access denied?
# Job links dont go to link, they redirect to '/'
# WHY?? How is this supposed to work?

post '/' do
  if settings.development?
    data = TestData.new
    jobs = data.test_data
  else
    profiler = CompanyProfiler.new(request.ip, request.user_agent)

    jobs = search( params[:terms], params[:location], profiler )
  end

  erb :table, :locals => { :jobs => jobs }
end
