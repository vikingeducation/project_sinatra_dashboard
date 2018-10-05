require 'sinatra'
require 'erb'
require 'pry-byebug'
require './helpers/jobs_helper.rb'
require 'json'
helpers JobHelper
helpers GeoLocation
helpers CompanyHelper
enable :sessions

get '/' do
  request.ip == "127.0.0.1" ? ip = "216.58.193.110" : request.ip
  if session[:city].nil?
    location = JSON.parse(location(ip).body)
    city = "#{location['city']}%2C+#{location['region_code']}" if session[:city].nil?
    city.gsub!(/\s/, "+")
    session[:city] = city
  end
  puts "User city - #{session[:city]}"
  erb :index
end

post '/search' do
  @search_text = params[:search_text]
  if @jobs == nil
    @jobs = get_jobs(@search_text, 3)
    @reviews = get_reviews(@jobs)
  end
  erb :index
end