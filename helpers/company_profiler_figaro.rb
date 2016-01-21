require 'figaro'


# Load Figaro
Figaro.application = Figaro::Application.new(
  environment: "development",
  path: "../config/application.yml"
)
Figaro.load

