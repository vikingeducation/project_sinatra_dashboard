require "sinatra"
require "sinatra/reloader" if development?


get "/job_search" do



erb :job_search

end