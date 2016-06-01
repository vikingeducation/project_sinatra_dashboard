require 'sinatra'
require 'sinatra/reloader' if development?
require 'thin'
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'erb'
require 'json'
require 'pry-byebug'
require './lib/scraper'

enable :sessions
set :session_secret, '*&(^B234'

# helpers

get '/' do
  erb :index
end

post '/jobs' do
  scraper = SearchJobs.new
  results = scraper.get_jobs(params[:searchTerms])
  erb :index, locals: { results: results }
end
