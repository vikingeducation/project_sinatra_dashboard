module SessionHelper

  def save_location(location)
    session[:location] = location.to_json
  end

  def get_location
    JSON.parse(session[:location])
  end

end
