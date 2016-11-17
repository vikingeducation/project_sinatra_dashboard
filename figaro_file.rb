
Figaro.application = Figaro::Application.new(
  path: File.expand_path("../config/application.yml", __FILE__)
  )
Figaro.load
