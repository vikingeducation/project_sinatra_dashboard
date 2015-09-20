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

  # only get location once evert 24 hours
  unless request.cookies["zipcode"]
    ip = settings.development? ? "99.68.49.223" : request.ip
    response.set_cookie("zipcode", :value => VisitorLocation.new.zipcode(ip),
                        :expires => Time.now + 86400 )
  end 

  gon.location = request.cookies["zipcode"] 
  
  erb :home
end


post '/search' do
  @keywords = params[:keywords].split(" ")
  @locations = params[:locations].split(" ")
  gon.location = request.cookies["zipcode"] 
  session[:keywords] = @keywords
  session[:locations] = @locations

  @previous_results = load_jobs_csv
  old_job_ids = @previous_results.nil? ? [] : existing_csv_job_ids

  @new_results = DiceJobs.new.search(@keywords, @locations, old_job_ids)

  if @new_results.empty?
    @message = '¯\_(ツ)_/¯ No New Results!'
  end

  save_jobs_csv(@new_results)

  erb :home
end


get '/company/' do
  id = params[:id]
  name = params[:name]

  @profile = load_company_profile_csv(id)
  if @profile.nil?
    @profile = CompanyProfiler.new.get_profile(name)
    @profile["company_name"] = name
    @profile["company_id"] = id
    save_companies_csv(@profile)
  end

  erb :company_profile
end