require 'sinatra'
require 'erb'
require 'pry-byebug'

enable :sessions

get '/' do
  erb :index
end