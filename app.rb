require 'sinatra'
require 'json'
require 'pry-byebug'
require './helpers.rb'
require './job_scraper.rb'

enable :sessions

include Helper

get '/' do

	session.clear

	erb :layout

end

post '/search' do

	job      = params[ :job ]
	location = params[ :location ]
binding.pry
	parse_job( job, location )

	save_session

	erb :layout, locals: { csv: @csv }

end
