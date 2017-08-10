# app.rb
require 'sinatra'
require 'erb'
require 'sinatra/reloader'
require 'pry-byebug'

enable :sessions

get '/' do
  erb :index
end

post '/search' do
  redirect to('/')
end
