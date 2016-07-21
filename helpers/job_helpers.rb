require_relative './dice_scraper'

module JobHelpers
  def get_results(q, l)
    DiceScraper.new(q, l).create_listings_array
  end

end