require 'sinatra'
require 'json'
require 'pry-byebug'
require './helpers.rb'
require './job_scraper.rb'

enable :sessions

include Helper

get '/' do

	new_job_search

	save_session
binding.pry
	erb :layout, locals: { job_csv: @csv }

end
