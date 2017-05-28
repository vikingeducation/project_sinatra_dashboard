require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

require './helpers/job_dashboard_helpers'
require './helpers/job_site_scraper'
require './helpers/locator'

helpers JobDashboardHelpers

enable :sessions

get '/' do
  if settings.development?
    request_ip = "202.40.249.81"
  else
    request_ip = request.ip
  end

  visitor_location = load_visitor(request_ip)
  city = visitor_location[0]
  country = visitor_location[1]

  locals = {
    request_ip: request_ip,
    country: country,
    city: city
  }

  save_visitor(city, country)

  erb :index, locals: locals
end

get "/search" do
  job_search_term = params[:job_search_term]
  job_location = params[:job_location]

  scraper = JobSiteScraper.new
  job_postings = scraper.scrape_job_postings(job_search_term, job_location)

  erb :index, locals: { job_postings: job_postings }
end
