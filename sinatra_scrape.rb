#!/usr/bin/env ruby
require 'thin'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'pry'

set :server, "thin"
require './helpers/parser.rb'
# require './helpers/scraper.rb'
require './helpers/visitor_ip.rb'
enable :sessions
helpers Parser

get '/' do
	@user_ip = VisitorIP::GetIP.new(request.ip).user_location
	session[:user_ip] = @user_ip
	erb :index
end

post '/search_results' do
	city = session[:user_ip][0]
	description = params[:job_description]
	location = params[:location]
	results = Parser::WriteJobs.new(description, location, request.ip).result
	erb :search_results, :locals => {results: results, city: city}
end


# class MyApp < Sinatra::Base
# run! if app_file == $0    #run sinatra if this is the main file
# end