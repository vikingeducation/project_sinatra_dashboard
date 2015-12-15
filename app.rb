require 'sinatra'
require 'sinatra/partial'
require 'sinatra/reloader' if development?
require 'erb'
require 'json'
require 'uri'
require 'pry' if development?
require 'httparty'
require 'envyable'
# Load secrets
Envyable.load('env.yml')

require_relative 'dice_scraper'
require_relative 'company_profiler'

# Options for partials
set :partial_template_engine, :erb
enable :partial_underscores

# Saves search terms
enable :sessions




# ****************************
#     Routes and controls
# ****************************
get '/' do

  if session[:keywords] || session[:location]
    dice_results = DiceScraper.new(session[:keywords], session[:location])
    jobs = dice_results.jobs
    erb :index, locals: {jobs: jobs, show_results: true, location: session[:location]}
  else
    erb :index, locals: {show_results: false}
  end
end

post '/scrape/new' do
  session[:keywords] = params[:keywords]
  if params[:location] != ''
    session[:location] = params[:location]
  else
    # Hard-code IP when in development
    Sinatra::Base.development? ? ip_address = '174.70.110.150' : ip_address = request.ip

    # Get geo-location of IP
    uri = "http://freegeoip.net/json/#{ip_address}"
    location_response = HTTParty.get(uri)
    city = location_response["city"]
    state = location_response["region_code"]
    country = location_response["country_code"]
    session[:location] = "#{city}, #{state}, #{country}"
  end

  redirect to('/')
end

post '/results/clear' do
  session[:keywords] = nil
  session[:location] = nil

  redirect to('/')
end

get '/company/:name' do
  company_string = params[:name]
  agent = URI.escape(request.user_agent.split(' ').first)
  ip = request.ip

  profile = CompanyProfiler.new(company_string, agent, ip)
  company_object = profile.company
  featured_review_object = company_object['featuredReview']

  erb :company, locals: {company: company_object, review: featured_review_object}
end