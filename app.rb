require 'rubygems'
require 'dotenv/load'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry'

# Classes
require './models/scraper.rb'
require './models/free_geo_api.rb'
require './models/company_profiler.rb'

# Routes
enable :sessions

get '/' do
  # Build objects
  settings.development? ? user_ip = ENV['EX_IP_ADDRESS'] : user_ip = request.ip
  geo_api = FreeGeoAPI.new(user_ip)
  location = geo_api.send_request

  # Save objects to session
  session['user_ip'] = user_ip

  # Output data to view
  erb :index, locals: { keyword: nil, location: location, jobs: nil, user_ip: user_ip }
end

# Prevent timeout while scraping dice.com
set :server_settings, :timeout => 3600

post '/search' do
  user_ip = session['user_ip']
  keywords = params['keywords']
  location = params['location']
  distance = params['distance']
  params['remote'] ? remote = 'true' : remote = ''

  scraper = Scraper.new
  scraper.scrape(keywords: keywords, location: location, distance: distance, remote: remote)

  session['keyword'] = keyword
  session['location'] = location

  redirect('/results')
end

get '/results' do
  keyword = session['keyword']
  location = session['location']
  user_ip = session['user_ip']
  scraper = Scraper.new
  matches = scraper.retrieve_matches_from_yaml

  erb :index, locals: { keyword: keyword, location: location, jobs: matches, user_ip: user_ip }
end

get '/job' do
  id = params['id']
  scraper = Scraper.new
  matches = scraper.retrieve_matches_from_yaml
  job = matches.select { |match| match.job_id == id }.first

  erb :job, locals: { job: job }
end

get '/company' do
  name = params['name']
  location = params['location']
  user_agent = request.user_agent.split(' ').first
  user_ip = session['user_ip']

  profiler = CompanyProfiler.new(user_ip, user_agent)
  company = profiler.send_request(name, location)

  erb :company, locals: { company: company }
end