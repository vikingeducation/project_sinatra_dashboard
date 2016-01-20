require 'sinatra'
require 'httparty'
require 'thin'
require 'mechanize'
require 'byebug'
require 'chronic'
require 'csv'
require 'sinatra/reloader' if development?
require_relative 'figaro_setup' if development?
require_relative 'lib/scraper'
require_relative 'lib/location'
require_relative 'lib/glass_door'

also_reload 'lib/*'

enable :sessions

helpers do
  def user_location
    if Sinatra::Base.development?
      session[:location] = Location.location_for('24.130.159.134')
    else
      session[:location] ||= Location.location_for(request.ip)
    end
  end
end

get '/' do
  job_results = []
  if query = params[:job_query]
    job_results = DiceScraper.new(user_location).scrape_jobs(query)
  end
  erb :job_search, locals: {job_results: job_results}
end

get '/company/:company_name' do
  company_name = params[:company_name]
  company = GlassDoor.for_company(company_name, request.ip, request.user_agent)
  company
  erb :show_company, locals: {company: company}
end
