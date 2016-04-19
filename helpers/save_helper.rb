module SaveHelper
  def save_ip( user )
    response.set_cookie("ip", user[:ip])
    response.set_cookie("user_agent", user[:user_agent])
    response.set_cookie("city", user[:city])
    response.set_cookie("country_code", user[:country_code])
  end
end