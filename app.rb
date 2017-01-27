require "sinatra"
require "sinatra/reloader" if development?
require './helpers/locator.rb'
enable :sessions

get '/' do
  ip = request.ip
  ip = '72.229.28.185' if ip == '::1'
  session['geodata'] = Locator.new(ip)
  # development? ? session['geodata'] = Locator.new('72.229.28.185') : session['geodata'] = Locator.new
  erb :index, locals: { geodata: session['geodata'] }
end