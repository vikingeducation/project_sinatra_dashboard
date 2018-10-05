require 'sinatra'
require 'sinatra/reloader' if Sinatra::Base.development?
require 'thin'
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'erb'
require 'json'
require 'pry-byebug'
require './lib/scraper'
require './lib/geolocation'
require './helpers/session_helper'

enable :sessions
set :session_secret, '*&(^B234'

helpers SessionHelper

get '/' do
  ip = Sinatra::Base.development? ? "192.34.60.57" : request.ip
  location = GeoLocation.new(ip).response
  save_location(location)
  erb :index, locals: { results: nil }
end

post '/jobs' do
  scraper = SearchJobs.new
  results = scraper.get_jobs(params[:searchTerms], get_location["city"])
  erb :index, locals: { results: results, term: params[:searchTerms], location: get_location["city"] }
end
