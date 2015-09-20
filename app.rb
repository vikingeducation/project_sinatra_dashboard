#!/usr/bin/env ruby
require './dice_jobs'
require './visitor_location.rb'
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

  #DiceScraper.new(@keywords, @zipcodes).build_csv
  #@results = CSV.read('jobs.csv', headers:true)
  @results = DiceJobs.new.search(@keywords, @locations)
  erb :home
end