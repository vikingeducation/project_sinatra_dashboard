require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

get '/' do
  "The beginning of our great dashboard."
end
