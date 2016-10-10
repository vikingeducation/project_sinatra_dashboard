require 'sinatra'
require 'json'
require 'pry-byebug'
require './helpers.rb'
require './job_scraper.rb'
require 'haml'

enable :sessions

include Helper

get '/' do

	session.clear

	@ip = request.env[ 'REMOTE_ADDR' ].split(',').first
	#haml :index

	save_ip
binding.pry
	erb :layout

end

post '/search' do

	job      = params[ :job ]
	location = params[ :location ]

	parse_job( job, location )

	save_session

	erb :layout, locals: { csv: @csv }

end
