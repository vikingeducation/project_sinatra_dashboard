module DashboardHelper
  def params_to_opts(params)
    params = params.map do |param|
      param = [param[0], param[1].gsub(' ', '+').gsub(',', '%2C')]
    end
    params.to_h
  end

  def set_session(ip)
    session['ip'] = ip
    set_location(ip) unless session['location']
  end

  def set_location(ip)
    locator = Locator.new(ip)
    location = parse_locator(locator.response)
    session['location'] = location
  end

  def parse_locator_response(location)
    search = location.parsed_response['city']
    search += ', ' + location.parsed_response['region_code'].match(/\d+/) unless location.parsed_response['region_code'].match(/\d+/)
  end

  def display_form(advanced)
    form = advanced ? :advanced_search_form : :search_form
  end

  def merge_data(listings, ratings)
    listings.each do |listing|
      ratings.each do |rating|
        if listing.company.include?(rating.company)
          listing.overall = rating.overall
          listing.culture = rating.culture
          listing.compensation = rating.compensation
          listing.featured = rating.featured
        end
      end
    end
    listings
  end


end
