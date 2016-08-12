require 'sinatra'
require 'mechanize'
require "sinatra/reloader" if development?
require 'pry-byebug'
require './helpers/app_helper.rb'

helpers AppHelper

enable :sessions

get '/' do
  erb :index
end
