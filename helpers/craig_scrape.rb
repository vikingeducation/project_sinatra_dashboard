require 'mechanize'

Listing = Struct.new(:name, :link, :email, :price, :location)

class CraigScraper
  def initialize(min_ask, max_ask, keywords)
    @listings = []
    @scraper = Mechanize.new
    @scraper.history_added = proc { sleep 0.5 }
    @min = min_ask
    @max = max_ask
    @keywords = keywords
  end

  def form_submit
    @scraper.get('http://sfbay.craigslist.org/apa') do |page|
      form = page.forms[1]
      form['minAsk'] = @min
      form['maxAsk'] = @max
      form['query'] = @keywords
      @results_page = form.submit
    end # performing the search from the apts/housing page
  end

  def listings
    form_submit

    @results_page.links_with(href: %r{\/.{3}\/apa}).each do |link|
      current_listing = Listing.new

      current_listing.name = link.text.strip
      current_listing.link = 'http://sfbay.craigslist.org' + link.uri.to_s

      description_page = link.click

      current_listing.price = description_page.search('.price').text.strip
      current_listing.location = description_page.search('//*[@id="pagecontainer"]/section/h2/span[2]/small').text.gsub("(", "").gsub(")", "").strip

      @listings << current_listing
    end
  end

  def render_listings
    @listings.each do |listing|
      puts "#{listing.name}"
    end
  end
end

test = CraigScraper.new(1000, 3000, 'family')
test.get_listings
test.render_listings
