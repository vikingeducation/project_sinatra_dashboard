require 'sinatra'
require 'sinatra/reloader'
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
  "<h1>Hello, Stephen</h1>"
end
