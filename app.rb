require 'sinatra'
require 'sinatra/reloader' if development?


get '/' do
  job_results = []
  if query = params[:job_query]
    job_results = ["#{query}", "Cisco", "Facebook"]
  end  
  erb :job_search, locals: {job_results: job_results}
end

# post '/boss' do
#   boss_message = "WHAT DO YOU MEAN, '#{params[:message].upcase}'????? YOU'RE FIRED!!"
#   erb :boss_response, locals: { boss_message: boss_message}
# end
