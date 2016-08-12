require 'sinatra'
require 'pry-byebug'
require './helpers/app_helper.rb'

helpers AppHelper

enable :sessions

get '/' do
  erb :index
end
