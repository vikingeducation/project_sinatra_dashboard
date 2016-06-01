require 'sinatra'
require 'sinatra/reloader' if development?
require 'thin'
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'erb'
require 'json'
require 'pry-byebug'

enable :sessions
set :session_secret, '*&(^B234'

# helpers

get '/' do
  erb :index
end

post '/jobs' do
  "these are #{params[:searchTerms]}"
end
