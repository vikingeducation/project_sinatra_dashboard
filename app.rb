require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'mechanize'
require 'csv'

get '/' do
  erb :index
  #run scraper if search
end