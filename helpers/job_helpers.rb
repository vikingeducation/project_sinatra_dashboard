require_relative './dice_scraper'

module JobHelpers
  def get_results(q, l)
    DiceScraper.new(q, l).create_listings_array
  end

  def build_url(base, parameters)
    url = base
    params = []
    parameters.each do |key, value|
      params << "#{key}=#{value}"
    end
    url << params.join("&")
  end

end