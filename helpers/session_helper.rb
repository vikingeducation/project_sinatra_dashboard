module SessionHelper

  def set_session
    if session['zip'].nil?
      locator = Locator.new
      locator.get_api_location('108.185.219.255')
      session['city'] = locator.city
      session['region'] = locator.region
      session['zip'] = locator.zip
    end
  end

  def set_profiler(results)
    profiler = CompanyProfiler.new
    profiler.get_profiles(results)
  end

end
