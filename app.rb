require 'sinatra/base'
require 'nokogiri'
require 'csv'
require 'json'
require 'pry-byebug'
require './helpers/helpers.rb'
require './job_scraper.rb'
require 'haml'
require './geo_location.rb'


class App < Sinatra::Base



enable :sessions
set :server, 'thin'
set :environment, :development


helpers Helper

get '/' do

	session.clear

	get_location

	save_ip

	erb :layout

end

post '/search' do

	job      = params[ :job ]
	location = params[ :location ]

	parse_job( job, location )

	save_session

	erb :layout, locals: { csv: @csv }

end

	run! if app_file == $0

end
