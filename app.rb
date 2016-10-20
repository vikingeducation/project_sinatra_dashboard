require 'sinatra/base'
require 'nokogiri'
require 'csv'
require 'json'
require 'pry-byebug'
require './helpers/helpers.rb'
require './job_scraper.rb'
require './glass_door.rb'


class App < Sinatra::Base



enable :sessions
set :server, 'thin'
set :environment, :development


helpers Helper

get '/' do

	session.clear

	get_location

	save_ip

	erb :layout, locals: { city: @location["city"], state: @location["region_code"]}

end

post '/search' do

	job      = params[ :job ]
	location = params[ :location ]

	parse_job( job, location )
	add_review
	save_session

	erb :display, locals: { csv: @csv, city: "", state: "" }

end

	run! if app_file == $0

end
