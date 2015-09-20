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

  ip = settings.development? ? "99.68.49.223" : request.ip
  gon.location =  VisitorLocation.new.zipcode(ip)
  
  erb :home
end


post '/search' do
  @keywords = params[:keywords].split(" ")
  @locations = params[:locations].split(" ")
  session[:keywords] = @keywords
  session[:locations] = @locations

  #DiceScraper.new(@keywords, @zipcodes).build_csv
  #@results = CSV.read('jobs.csv', headers:true)
  @results = DiceJobs.new.search(@keywords, @locations)
  erb :home
end