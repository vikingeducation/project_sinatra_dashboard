require "sinatra"
require "sinatra/reloader" if development?
require "erb"
require "bundler/setup"
require "./dice_scrape/dice_web_scraper.rb"
require "./helpers/session_helper.rb"
require 'open-uri'
require 'json'
require './company_profiler'

helpers SessionHelper

enable :sessions

get '/' do
	ip = "54.240.196.185"
	save_ip(ip)
  	erb :index, locals: { ip: ip }
end

post '/jobs' do
	search_term = params[:job_title]
	ip = load_ip
	buffer = open("https://freegeoip.net/json/#{ip}").read
	response = JSON.parse(buffer)
	scraper = DiceWebScraper.new(search_term, response['zip_code'])
	scraper.scrape
	scraper.save
	jobs = []
	index = 0
	CSV.foreach("jobs.csv") do |row|
  		jobs << row
  		cp = CompanyProfiler.new(row[1])
  		cv_rating = cp.run
  		jobs[index][7] = cv_rating
  		index += 1
	end
	erb :jobs, locals: { jobs: jobs[1..jobs.size-1], city: response['city'], state: response['region_code'] }
end