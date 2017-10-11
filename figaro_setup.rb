require 'figaro'

Figaro.application = Figaro::Application.new(path: "config/application.yml")
Figaro.load
