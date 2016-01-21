require 'sinatra'
require 'thin'
require 'erb'
require 'mechanize'
require 'chronic'
require 'byebug'
require 'csv'
# require 'sinatra/reloader' if development?
require_relative 'helpers/scraper'
require_relative 'helpers/locator'
require_relative 'helpers/company_profiler'

enable :sessions
set :servers, ["thin", "puma", "webrick"]


helpers do 

  def glassdoor_results(job_results)
    companies = []
    checked_companies = []
    job_results.each do |job|
      if checked_companies.include?(job.company)
        index = checked_companies.index(job.company)
        companies << companies[index]
      else
        profiler = CompanyProfiler.new(job.company)
        companies << profiler.company
        checked_companies << job.company
      end
    end
    companies
  end

end


get '/' do
  locator = Locator.new #(request.ip)
  location = locator.readable_location
  session['location'] = location
  erb :index, :locals => { :location => location }
end


post '/' do
  search_term = params[:search]
  job_results = DiceScraper.new(session['location']).run(search_term)
  glassdoor_results = glassdoor_results(job_results)
  erb :dashboard, :locals => { :job_results => job_results, :location => session['location'], :glassdoor_results => glassdoor_results }
end

