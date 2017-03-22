require "sinatra"
require "sinatra/reloader" if development?

enable :session

get "/" do
  "Hello world"
end
