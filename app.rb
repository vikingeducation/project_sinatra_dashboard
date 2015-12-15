require 'sinatra'
require 'sinatra/partial'
require 'sinatra/reloader' if development?
require 'erb'
require 'json'
require 'pry'
require_relative 'dice_scraper'

# options for partials
set :partial_template_engine, :erb
enable :partial_underscores

# saves search terms
enable :sessions




# ****************************
#     Routes and controls
# ****************************
get '/' do

  if session[:keywords] || session[:location]
    dice_results = DiceScraper.new(session[:keywords], session[:location])
    jobs = dice_results.jobs
    erb :index, locals: {jobs: jobs, show_results: true}
  else
    erb :index, locals: {show_results: false}
  end
end

post '/scrape/new' do
  session[:keywords] = params[:keywords]
  session[:location] = params[:location]

  redirect to('/')
end

post '/results/clear' do
  session[:keywords] = nil
  session[:location] = nil

  redirect to('/')
end