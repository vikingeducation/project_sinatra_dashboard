require "sinatra"
require "sinatra/reloader" if development?
require './helpers/locator.rb'
require './helpers/company_profiler.rb'
require './helpers/dice_web_scraper.rb'

enable :sessions

get '/' do
  ip = request.ip
  ip = '72.229.28.185' if ip == '::1' # ip = '::1' in development
  session['geodata'] = Locator.new(ip)
  erb :index, locals: { geodata: session['geodata'] }
end

get '/jobs' do
  if session['job_site'] == 'dice'
    jobs = DiceWebScraper.new(session['jobs_query'], session['zip_code'], session['radius'], session['num_jobs']).jobs
  # elsif session['job_site'] == 'some_other_site'
  # jobs = SomeOtherScraper.new(...)
  # ...
  end
  employers = []
  if session['glassdoor'] == 'yes'
    jobs.each do |job|
      query = job['company']
      employer = CompanyProfiler.new(query).employers[0]
      employers << employer
    end
  end
  erb :jobs, locals: { query: session['jobs_query'], zip_code: session['zip_code'], radius: session['radius'], glassdoor: session['glassdoor'], jobs: jobs, employers: employers}
end

get '/companies' do
  employers = CompanyProfiler.new(session['company_query']).employers
  erb :companies, locals: { query: session['company_query'], num_results: session['company_num_results'], employers: employers }
end

post '/search_jobs' do
  # input validation here
  session['jobs_query'] = params[:query]
  session['job_site'] = params[:job_site]
  session['zip_code'] = params[:zip_code]
  session['radius'] = params[:radius].to_i
  session['num_jobs'] = params[:num_jobs].to_i
  session['glassdoor'] = params[:glassdoor]
  redirect to('/jobs')
end

post '/search_companies' do
  # input validation here
  session['company_query'] = params[:query]
  session['company_num_results'] = params[:num_results].to_i
  redirect to('/companies')
end

