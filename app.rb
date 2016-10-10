require 'sinatra/base'
require 'nokogiri'
require 'json'
require 'pry-byebug'
require './helpers.rb'
require './job_scraper.rb'
require 'haml'
require './geo_location.rb'



class App < Sinatra::Base

set :server, ['thin']
set :environment, :development

enable :sessions

include Helper

get '/' do

	session.clear

	@ip = request.ip

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

	run! if app_file == $0

end
