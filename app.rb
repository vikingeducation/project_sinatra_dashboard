require 'mechanize'
require 'rubygems'
require 'pry'
require 'csv'
require 'sinatra'
require './web_scraper.rb'
require '.locator.rb'
enable :sessions

get '/' do 
	#jobs = JobHunter.new
	#results = jobs.get_me_a_job

	erb :index
end

post '/show_job' do

	@job = params[:job]
	@location = params[:location]

	jobs = JobHunter.new(@job, @location)
	results = jobs.get_me_a_job

	erb :show_job, locals: {location: @location, job: @job, data: results}

end

get '/show_job' do 

	erb :show_job
end