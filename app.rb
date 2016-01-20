#!/usr/bin/env ruby
require 'sinatra'
require "sinatra/reloader" if development?

get '/' do

  erb :index
end


post '/' do

  results = params[:results]
  erb :index, locals = {results: results}
end