require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'mechanize'

get '/' do
  erb :index
end