require "sinatra"
require "sinatra/reloader"
require "erb"

enable :sessions

get '/' do
  "hello, world PSYCH!"
end
