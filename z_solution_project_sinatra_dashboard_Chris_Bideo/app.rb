require 'sinatra'
require 'erb'
require 'mechanize'
require 'uri'
require 'thin'
require 'cgi'

require_relative 'lib/csv_loader.rb'
require_relative 'lib/csv_saver.rb'
require_relative 'lib/dice_task.rb'
require_relative 'lib/glassdoor_api.rb'
require_relative 'lib/scraper.rb'
require_relative 'lib/telize_api.rb'
require_relative 'lib/yaml_loader.rb'
require_relative 'lib/yaml_saver.rb'
require_relative 'lib/scrape_task.rb'
require_relative 'lib/scraper.rb'

set :servers, ['thin', 'puma', 'webrick']
enable :sessions

env = YAMLLoader.new
env.load("#{File.dirname(__FILE__)}/env.yaml")

if Sinatra::Base.development?
	puts "IP: #{env.ip}"
	IP = env.ip
else
	IP = request.ip
end

helpers do
	def company_name(str)
		str.split(/[^a-z0-9]/i).select {|i| !i.empty?}.join('_').downcase
	end
end

before /^(?!\/locate)/ do
	redirect '/locate' unless session[:location]
end

get '/' do
	locals = {
		:location => session[:location]
	}
	csv_loader = CSVLoader.new
	data = csv_loader.load("#{File.dirname(__FILE__)}/lib/data/jobs.csv")
	locals[:data] = data
	erb :'layout.html', :locals => locals do
		erb :'index.html', :locals => locals
	end
end

get '/locate' do
	telize = TelizeAPI.new
	telize.locate(IP)
	session[:location] = telize
	redirect '/'
end

get '/company/:name/:location' do
	query = params[:name]
	location = params[:location]
	ip = IP
	user_agent = request.env['HTTP_USER_AGENT']
	glassdoor = GlassdoorAPI.new(
		:id => env.glassdoor_partner_id,
		:key => env.glassdoor_api_key,
		:ip => ip,
		:user_agent => user_agent
	)
	glassdoor.search(query, location)

	locals = {
		:data => glassdoor.data
	}

	erb :'layout.html', :locals => locals do
		erb :'company.html', :locals => locals
	end
end

post '/scrape' do
	query = params['q']
	location = params['location']

	unless query.empty? || location
		dice_task = DiceTask.new(
			:query => query,
			:location => location
		)
		scraper = Scraper.new(:task => dice_task)
		scraper.scrape
		unless scraper.data.empty?
			if scraper.data[:jobs].empty?
				message = URI::encode('No jobs found')
				redirect "/?error=#{message}"
			else
				csv_saver = CSVSaver.new
				csv_saver.save(scraper.data[:jobs], "#{File.dirname(__FILE__)}/lib/data/jobs.csv")
				redirect '/'
			end
		else
			message = URI::encode('There was an error while scraping')
			redirect "/?error=#{message}"
		end
	else
		message = URI::encode('Cannot leave fields empty')
		redirect "/?error=#{message}"
	end
end



