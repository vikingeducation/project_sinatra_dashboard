#!/usr/bin/env ruby
require './dice_jobs'
require './company_profiler.rb'
require './visitor_location.rb'
require './helpers/store_results.rb'

require 'sinatra'
require 'gon-sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug' if development?

helpers StoreResults
Sinatra::register Gon::Sinatra
enable :sessions


get '/' do
  # search boxes pre-populated with previous search
  @keywords = session[:keywords].nil? ? Array.new : session[:keywords]
  @locations = session[:locations].nil? ? Array.new : session[:locations]
  @previous_results = load_jobs_csv

  # only get location once every 24 hours, otherwise initial page load is slow
  unless request.cookies["zipcode"]
    ip = settings.development? ? "99.68.49.223" : request.ip
    location = VisitorLocation.new.best_location(ip)

    gon.location = location # needed for first page load
    response.set_cookie("zipcode", :value => location,
                        :expires => Time.now + 86400 )
  end 

  # so we can set location within javascript
  if request.cookies["zipcode"] 
    gon.location = request.cookies["zipcode"] 
  end
  
  erb :home
end


post '/search' do
  # repopulate keyword and location fields
  @keywords = params[:keywords].split(" ")
  @locations = params[:locations].split(" ")
  gon.location = request.cookies["zipcode"] 

  # save last search to session, so we see it when we come back
  session[:keywords] = @keywords
  session[:locations] = @locations

  @previous_results = load_jobs_csv
  # get job ids from previous results, won't bother rescraping on dice
  old_job_ids = @previous_results.nil? ? [] : existing_csv_job_ids

  @new_results = DiceJobs.new.search(@keywords, @locations, old_job_ids)

  if @new_results.empty?
    @message = '¯\_(ツ)_/¯ No New Results!'
  end

  save_jobs_csv(@new_results)

  erb :home
end


get '/company' do
  # dice company name and ID
  id = params[:id]
  name = params[:name]

  # see if we can load an existing profile and avoid hitting glassdoor API
  @profile = load_company_profile_csv(id)
  if @profile.nil?
    @profile = CompanyProfiler.new.get_profile(name)
    if @profile.nil?
      # If profile is still nil, Glassdoor couldn't find the company.
      @message = "Can't find company on Glassdoor!"
    else
      @profile["company_name"] = name
      @profile["company_id"] = id
      save_companies_csv(@profile)
    end
  end

  erb :company_profile
end