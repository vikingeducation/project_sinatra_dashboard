
require_relative 'web_scrapper.rb'
require 'rubygems'
require 'mechanize'


module JobHuntHelper
  include JobScrapper

  def all_jobs(city, keyword, company, date)
    WebScrapper.new.parse_all_job_adverts(city, keyword, company, date)
  end

end