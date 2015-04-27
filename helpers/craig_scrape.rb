require 'mechanize'

Listing = Struct.new(:name, :link, :email, :price, :location)

class CraigScraper

  def initialize
    @listings = []
  end

  def get_listings

    scraper = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.history_added = Proc.new { sleep 0.5 } # just in case
    end

    scraper.get('http://sfbay.craigslist.org/apa') do |page|

      page.links_with(href: /\/.{3}\/apa/).each do |link|

        current_listing = Listing.new

        current_listing.name = link.text.strip
        current_listing.link = 'http://sfbay.craigslist.org' + link.uri.to_s

        description_page = link.click

        current_listing.price = description_page.search('.price').text.strip
        current_listing.location = description_page.search('//*[@id="pagecontainer"]/section/h2/span[2]/small').text.gsub("(", "").gsub(")", "").strip

        @listings << current_listing

      end
    end
  end

end
