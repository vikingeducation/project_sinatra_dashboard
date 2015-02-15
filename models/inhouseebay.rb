class InHouseEbay
  attr_reader :page, :search_page, :item_header, :item_link, :search_page, :price, :all_items, :top_price
  def initialize(keyword, top_price)
    agent = Mechanize.new
    @top_price = top_price
    agent.history_added = Proc.new {sleep 0.5}
    @page = agent.get('http://www.ebay.com/')
    my_form = page.form_with(:id => "gh-f")
    my_form._nkw = keyword
    @max_price = price
    @search_page = agent.submit(my_form)    
    generate_results
  end

  def generate_results
    item_header
    link_to_page
    very_price
    top_items
  end

  def item_header
    @item_header = @search_page.search("a.vip").map {|item| item.text.strip}
  end
  
  def very_price
    @price = @search_page.search("span.bold").map {|item| item.text.strip}
  end

  def link_to_page
    @item_link = @search_page.links_with(:class => "vip")
.map {|item| item.href.strip}
  end

  def top_items
    @all_items = []
    counter = 0
    while @item_header[counter] != nil
      if @price[counter][1..-1].to_f > @top_price.to_f
        counter += 1
        next
      else
        current_item = SuchEbay.new
        current_item.title = @item_header[counter]
        current_item.link = @item_link[counter]
        current_item.price = @price[counter]
        @all_items << current_item
        counter += 1
      end
    end
  end
end