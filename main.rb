require 'sinatra'
require 'erb'
require 'csv'
require 'json'
require_relative 'helpers/jobsearch_helper.rb'

enable :sessions

def get_city
  agent = Mechanize.new
  ip = request.ip
  if ip == "127.0.0.1"
    ip = "67.160.188.113"
  end
  city = JSON.parse(agent.get("https://www.freegeoip.net/json/67.160.188.113").body)['city']
end
def get_region
  agent = Mechanize.new
  ip = request.ip
  if ip == "127.0.0.1"
    ip = "67.160.188.113"
  end
  region = JSON.parse(agent.get("https://www.freegeoip.net/json/67.160.188.113").body)['region']
end


get '/' do
  session[:city] = get_city
  session[:region] = get_region
  erb :index, locals: {city: session[:city], region: session[:region]}
end

post '/search' do
  job_keyword = params[:job]
  job_location = params[:location]

  web_scraper = WebScraper.new(job_keyword, job_location)
  web_scraper.loop_through_job
  web_scraper.all_data
  all_data = web_scraper.data
  web_scraper.write_csv
  erb :result, locals: {data: all_data, city: session[:city], region: session[:region]}
end