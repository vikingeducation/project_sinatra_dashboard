require 'rubygems'
require 'dotenv/load'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'csv'
require 'pry'

# Classes
require './models/job.rb'
require './models/scraper.rb'
require './models/free_geo_api.rb'
require './models/glassdoor_api.rb'

# Routes
enable :sessions

get '/' do
  # Build objects
  settings.development? ? user_ip = ENV['EX_IP_ADDRESS'] : user_ip = request.ip
  geo_api = FreeGeoAPI.new(user_ip)
  location = geo_api.send_request

  user_agent = request.user_agent
  glassdoor = GlassdoorAPI.new(user_ip, user_agent)
  response = glassdoor.send_request

  placeholder_job = Job.new

  # Modify objects
  placeholder_job.add_placeholder_info
  jobs = [placeholder_job, placeholder_job]

  # Save objects to session
  session['jobs'] = jobs
  session['user_ip'] = user_ip

  # Output data to view
  erb :index, locals: { keyword: nil, location: location, jobs: jobs, user_ip: user_ip }
end

# Prevent timeout while scraping dice.com
set :server_settings, :timeout => 3600

post '/search' do
  # Build objects
  user_ip = session['user_ip']
  keyword = params['title_keyword']
  location = params['location']
  scraper = Scraper.new('https://www.dice.com')

  # Modify objects
  matches = scraper.scrape(title: keyword, location: location)
  # jobs = CSV.parse("/Users/localflavor/Sites/rails_development/Viking/project_sinatra_dashboard/exports/jobs-2017-11-01 13:34:02 -0500.csv")
  # jobs = session['jobs']

  # Save objects to session

  # Output data to view
  erb :index, locals: { keyword: keyword, location: location, jobs: matches, user_ip: user_ip }
end