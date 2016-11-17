#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require 'figaro'
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

post '/' do
  if settings.development?
    data = TestData.new
    jobs = data.test_data
  else
    terms = params[:terms]
    location = params[:location]

    jobs = search(terms, location)
    jobs = convert_to_hashes(jobs)
  end

  # TODO move and make more OOP
  profiler = CompanyProfiler.new(request.ip, request.user_agent)

  jobs.map do |job|
    job[:glassdoor] = profiler.get_comp_info(job)
  end

  if jobs.empty?
    erb :no_jobs_found
  else
    erb :table, :locals => { :jobs => jobs }
  end
end
