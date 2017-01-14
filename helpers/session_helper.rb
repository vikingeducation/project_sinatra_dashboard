module SessionHelper

	def save_ip(ip)
		session[:user_ip] = ip
	end

	def load_ip
		session[:user_ip]
	end

end