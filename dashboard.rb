#!/usr/bin/env ruby

require "pry"
require "sinatra"
require "sinatra/reloader" if development?
require "thin"
require "mechanize"

get "/" do
  erb :index
end
