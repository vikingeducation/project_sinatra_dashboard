require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'
# require 'nokogiri'
# require 'open-uri'
# require 'csv'

class ApartmentSearcher
  attr_reader :page
  def initialize #(keyword, price)
    agent = Mechanize.new
    agent.history_added = Proc.new {sleep 0.5}
    @page = agent.get('http://www.ebay.com/')
    my_form = page.form_with(:id => "goToAddress")
    # my_form.query = keyword
    # @search_page = agent.submit(my_form)    
  end
end

binding.pry