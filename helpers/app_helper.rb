module AppHelper

  require './locator.rb'
  require './dice_scraper.rb'
  require './company_profiler.rb'

  # Locator pulls ZIP code based on client IP
  def session_location
    if session[:zip].nil?
      location = get_location
      save(location)
    else
      location = load_location
    end

    location
  end


  # Scraper pulls job postings directly from Dice.com
  def run_search(location)
    scraper = DiceScraper.new

    if params.nil?
      results = scraper.search(location)
    else
      results = scraper.search_with_params(params, location)
    end

    results
  end


  # Profiler uses GlassDoor's API to append company ratings & reviews to job listings
=begin
  def add_profiles!(results)
    profiler = CompanyProfiler.new

    results.each do |result|
      company = result[:company]
      # test valid company

      profile = profiler.get_profile(company)

      result[:GD_name] = profile[:name]
      result[:ratings] = profile[:ratings]
      result[:review] = profile[:review]

      sleep 0.5
    end

    results

  end
=end


  private


  def get_location
    locator = Locator.new
    locator.fetch_location
  end


  def save(location)
    session[:zip] = location
  end


  def load_location
    session[:zip]
  end

end