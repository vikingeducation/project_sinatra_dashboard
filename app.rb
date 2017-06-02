require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

require './helpers/job_dashboard_helpers'
require './helpers/job_site_scraper'
require './helpers/company_profiler'

helpers JobDashboardHelpers

enable :sessions

get '/' do
  visitor_location = load_visitor(request_ip)
  visitor_city = visitor_location[0]
  visitor_country = visitor_location[1]

  locals = {
    request_ip: request_ip,
    visitor_city: visitor_city,
    visitor_country: visitor_country
  }

  save_visitor(visitor_city, visitor_country)

  erb :index, locals: locals
end

get "/search" do
  job_search_term = params[:job_search_term]
  job_location = params[:job_location]

  visitor_location = load_visitor(request_ip)
  visitor_city = visitor_location[0]
  visitor_country = visitor_location[1]

  scraper = JobSiteScraper.new
  job_postings = scraper.scrape_job_postings(job_search_term, job_location)

  locals = {
    request_ip: request_ip,
    visitor_city: visitor_city,
    visitor_country: visitor_country,
    job_location: job_location,
    job_postings: job_postings
  }

  erb :index, locals: locals
end

# creating separate route for Glassdoor data due to
# slow response from their API
get "/glassdoor" do
  company = params[:company]
  location = params[:location]

  profiler = CompanyProfiler.new
  query = { q: company, l: location }

  company_data = profiler.build_company_data(query: query)

  locals = {
    company: company,
    company_data: company_data
  }

  erb :glassdoor, locals: locals
end
