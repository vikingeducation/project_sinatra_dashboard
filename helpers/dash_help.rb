require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'json'
require 'httparty'

class CompanyProfiler
  include HTTParty
  attr_accessor :company, :doc
  def initialize(company="")
    @company = company
    @doc
  end

  def info
    string = @company.gsub(" ", "-")
    temp = self.class.get("http://api.glassdoor.com/api/api.htm?v=1&format=json&action=employers&q=#{string}&userip=192.168.43.42&useragent=Mozilla/%2F4.0")
    @doc = temp["response"]["employers"][0]
  end
end

class Locator
  include HTTParty
  attr_accessor :ip, :location
  def initialize(ip)
    @ip = ip
    @location = nil
  end

  def loc
    @location = self.class.get("http://freegeoip.net/json/#{@ip}")
    string = "#{@location["city"]}, #{@location["region_code"]}"
    string
  end

end

module Dash
  HOME = 'http://www.dice.com'

  def add_info
    session["reviews"] = Hash.new
    session["jobs"].each do |job|
      job_info(job[1])
      sleep 0.1
    end
  end

  def job_info(job)
    c = CompanyProfiler.new(job)
    session["reviews"][job] = c.info
  end

  def get_loc(ip)
    l = Locator.new(ip)
    l.loc
  end

  def table
    lines = session["jobs"]
    string = ""
      lines.each do |line|
        string += "<tr>"
        line.each do |entry|
          string += "<td>#{entry}</td>"
        end
        string +="<td>#{session["reviews"][line[1]]["industryName"]}</td>"
        string += "</tr>"
      end
    string
  end

  def scrape(query="ruby stack", location="denver, co")
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
    session["jobs"] = job_rows


  end
end
