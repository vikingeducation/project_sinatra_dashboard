require '.\models\dice_scraper.rb'

module ScraperHelper
  def format_link(link)
    if link.include? "http"
      raw_link = link
      link.replace '<a href="' + raw_link + '">Link</a>'
    end
  end


end
