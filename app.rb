require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

require './helpers/job_site_scraper'
require './helpers/locator'

get '/' do
  if settings.development?
    request_ip = "202.40.249.81"
  else
    request_ip = request.ip
  end

  geodata = Locator.new.locate(request_ip)
  country = geodata["country_name"]
  city = geodata["city"]

  locals = {
    request_ip: request_ip,
    country: country,
    city: city
  }

  erb :index, locals: locals
end

get "/search" do
  job_search_term = params[:job_search_term]
  job_location = params[:job_location]

  scraper = JobSiteScraper.new
  job_postings = scraper.scrape_job_postings(job_search_term, job_location)

  erb :index, locals: { job_postings: job_postings }
end
