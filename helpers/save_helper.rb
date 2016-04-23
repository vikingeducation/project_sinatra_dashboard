module SaveHelper
  def save_ip( user )
    session[:ip] = user[:ip]
    session[:user_agent] = user[:user_agent]
    session[:city] = user[:city]
    session[:country_code] = user[:country_code]
  end
end