require "sinatra"
require "sinatra/reloader" if development?
require './helpers/locator.rb'
enable :sessions

get '/' do
  p "Your IP address is #{request.ip}"
  session['geodata'] = Locator.new('72.229.28.185')
  # development? ? session['geodata'] = Locator.new('72.229.28.185') : session['geodata'] = Locator.new
  erb :index, locals: { geodata: session['geodata'] }
end