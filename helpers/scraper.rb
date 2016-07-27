require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'


class Scraper

  attr_accessor :query, :location
  def initialize(query, location)
    @query = query
    @location = location

  end

  def scrape(query, location)

    agent = Mechanize.new
    home = agent.get(HOME)
    form = home.forms[1]
    form.q = query
    form.l = location
    results = agent.submit(form, form.buttons.first)

    indices = []
    results.links_with(:href => /jobs\/detail/).each do |link|
      indices << results.links.index(link)
    end
    hrefs = []
    results.links_with(:href => /jobs\/detail/).each do |link|
      hrefs << link.href
    end
    texts = []
    results.links_with(:href => /jobs\/detail/).each do |link|
       texts << link.text.strip
    end
    job_rows = []
    texts.each do |title|
      job_rows << [title]
    end
    job_rows.each_with_index do |row, i|
      row << results.links[indices[i]+1].text.strip
    end
    job_rows.each_with_index do |row, i|
      row << hrefs[i]
    end
    #add location
    job_rows.each do |row|
      mat = row[2].match(/(\w+-\w+)-\d{5}\/(.*)\/(.*)\?/)
      row << mat[1]
      row << mat[2]
      row << mat[3]
    end

    job_rows.uniq!
    binding.pry
    CSV.open('jobs.csv', 'a') do |csv|
      job_rows.each do |row|
        csv << row
      end
    end
  end

end
