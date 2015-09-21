#!/usr/bin/env ruby
require './dice_jobs'
require './company_profiler.rb'
require './visitor_location.rb'
require './google_sheets.rb'

require 'sinatra'
require 'gon-sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug' if development?

Sinatra::register Gon::Sinatra
enable :sessions


get '/' do

  # search boxes pre-populated with previous search
  @keywords = session[:keywords].nil? ? Array.new : session[:keywords]
  @locations = session[:locations].nil? ? Array.new : session[:locations]
  google_sheets = GoogleSheets.new
  @previous_results = google_sheets.load_jobs
  @page_title = "Home"

  # only get location once every 24 hours, otherwise initial page load is slow
  if request.cookies["zipcode"] 
    # so we can set location within javascript
    gon.location = request.cookies["zipcode"]

  else

   ip = settings.development? ? "99.68.49.223" : request.ip
    gon.location = VisitorLocation.new.best_location(ip)
    response.set_cookie("zipcode", :value => gon.location,
                        :expires => Time.now + 86400 )
  end
  
  erb :home

end


post '/search' do

  # repopulate keyword and location fields, load previous results
  @keywords = params[:keywords].split(" ")
  @locations = params[:locations].split(" ")
  google_sheets = GoogleSheets.new
  @previous_results = google_sheets.load_jobs
  gon.location = request.cookies["zipcode"]
  @page_title = "Search Results" 

  # save last search to session, so we see it when we come back
  session[:keywords] = @keywords
  session[:locations] = @locations

  # get job ids from previous results, won't bother rescraping on dice
  old_job_ids = @previous_results.nil? ? [] : google_sheets.existing_job_ids

  @new_results = DiceJobs.new.search(@keywords, @locations, old_job_ids)

  if @new_results.empty?
    @message = '¯\_(ツ)_/¯ No New Results!'
  end

  google_sheets.save_jobs(@new_results)

  erb :home

end


get '/company' do

  # dice company name and ID
  id = params[:id]
  name = params[:name]
  google_sheets = GoogleSheets.new
  @page_title = "#{name}"

  # see if we can load an existing profile and avoid hitting glassdoor API
  @profile = google_sheets.load_company_profile(id)

  if @profile.nil?

    @profile = CompanyProfiler.new.get_profile(name)

    if @profile.nil?
      # If profile is still nil, Glassdoor couldn't find the company.
      @message = "Can't find company on Glassdoor!"
    else
      @profile["company_name"] = name
      @profile["company_id"] = id
      google_sheets.save_company_profile(@profile)
    end

  end

  erb :company_profile

end