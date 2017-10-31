require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry'

# Routes
enable :sessions

get '/' do
  erb :index
end