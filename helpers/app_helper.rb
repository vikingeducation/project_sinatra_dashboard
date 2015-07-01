module AppHelper

  require './locator.rb'
  require './dice_scraper.rb'

  # Locator pulls ZIP code based on client IP
  def session_location(client_ip)
    if session[:zip].nil?
      location = get_location(client_ip)
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


  def get_location(client_ip)
    locator = Locator.new(client_ip)
    locator.fetch_location
  end


  def save(location)
    session[:zip] = location
  end


  def load_location
    session[:zip]
  end

end