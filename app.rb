require 'sinatra'
require 'nokogiri'
require 'json'
require 'pry-byebug'
require './helpers.rb'
require './job_scraper.rb'
require 'haml'

enable :sessions

set :server, 'thin'


include Helper

get '/' do

	session.clear

	@ip = request.ip

	save_ip
binding.pry
	erb :layout

end

post '/search' do
binding.pry
	job      = params[ :job ]
	location = params[ :location ]

	parse_job( job, location )

	save_session

	erb :layout, locals: { csv: @csv }

end
