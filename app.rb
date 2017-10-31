require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry'

# Classes
require './models/job.rb'
require './models/scraper.rb'

# Routes
enable :sessions

get '/' do
  erb :index
end