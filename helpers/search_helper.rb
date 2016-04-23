module SearchHelper

  def find_information
    ip = get_ip
    location = find_location( ip )
    city = location["city"].gsub!(" ", "_")
    country_code = location["countryCode"]
    { ip: ip, user_agent: get_user_agent, city: city, country_code: country_code }
  end

  def get_ip
    @env["REMOTE_ADDR"]
  end

  def find_location( ip )
    locator = Locator.new
    ip = "208.80.152.201" if ip == "::1"
    ip_response = locator.find_location( ip )
  end

  def get_user_agent
    @env["HTTP_USER_AGENT"]
  end

  def get_company_info( results )
    company_checked = {}
    results.each do |job|

      if company = job.company

        # look if the company has already been checked
        # if already checked, take the information from the saved one
        if company_checked.include?(company)
          job.company_data = company_checked[company]

        else
          
          company_info = CompanyProfiler.search( session[:ip], session[:user_agent], company )
          company_info = company_info["response"]["employers"][0]
          unless company_info.nil?
            
            new_company = CompanyData.new( company_info["cultureAndValuesRating"], 
                                           company_info["compensationAndBenefitsRating"], 
                                           company_info["workLifeBalanceRating"])
          end
          job.company_data = new_company
          company_checked[company] = job.company_data
        end
      end
    end
    results
  end

end










