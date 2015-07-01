module AppHelper

  require './locator.rb'
  require './dice_scraper.rb'

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