require 'sinatra'
require 'mechanize'
require "sinatra/reloader" if development?
require 'pry-byebug'
require './helpers/app_helper.rb'
require 'csv'

helpers AppHelper

enable :sessions

get '/' do
  erb :index
end

post '/search' do

  key = params[:key]

  liebao key
  result_liebao = CSV.open("result_liebao.csv")

  erb :result, :locals => { key: key, result_liebao: result_liebao }
end
