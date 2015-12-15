require 'sinatra'
require 'sinatra/partial'
require 'sinatra/reloader' if development?
require 'erb'
require 'json'
require 'pry'

# options for partials
set :partial_template_engine, :erb
enable :partial_underscores




# Routes and controls
get '/' do
  erb :index
end
