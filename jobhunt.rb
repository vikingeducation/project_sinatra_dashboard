require 'sinatra'
require 'json'
require './helpers/dice.rb'
require './helpers/gdhelper.rb'
require './helpers/ip_helper.rb'
require 'pry'

helpers Dice_scraper
helpers Glassdoorhelper
helpers IPhelper

enable :sessions

#session[:emp_db] = {}
#session[:ip] = nil
get '/' do
    ip = IPhelper::Ipfinder.new
    doc = "Your IP address is #{ip.ipjson["ip"]}"
    erb :welcome, :locals => {:doc => doc, :city => ip.ipjson["city"]}
end

get '/search' do
   job = params[:job]
   location = params[:place]
   dice_job = Dice_scraper::Dice_tool.new(job,location)
   #job_list = dice_job.jobdb
   session[:employers] = dice_job.employers
   erb :job_screen, :locals => {:job_list => dice_job.jobdb, :employer => dice_job.employers}
   #erb :test, :locals => {:job => job, :location => location}
end

get '/company' do
  name = params[:company]
  company = Glassdoorhelper::Gdhelper.new(name).gdresult
  #binding.pry
  erb :company, :locals => {:response => company}
end

