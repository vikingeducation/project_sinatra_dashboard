require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'csv'
require 'json'
require 'sinatra'

#module Dice_scraper
    class Dice_tool
    attr_accessor :joblist, :jobdb
    
        def initialize(job = "Ruby on Rails", place = "New York")
           agent = Mechanize.new
           agent.history_added = Proc.new { sleep 0.5 }
           page = agent.get('http://www.dice.com/')
           page_form = page.form_with(:action => '/jobs')
           page_form.q = job
           page_form.l = place
           result = page_form.submit
           @joblist = result.links_with :href => /jobs\/detail\//
           @jobdb = []
           synthesis
        end
       
        def savedata(array)
        CSV.open('scraper.csv', 'a') do |csv|
           csv << array
            end
        end
        
        def synthesis
            @joblist.each do |joblink|
                jobhash = {}
                job = joblink.click
                title = job.parser.css("title").text
                jobhash[:jobId] = job.parser.css("meta[name = 'jobId']").attribute('content').value
                jobhash[:jobTitle] = job.parser.css("h1[class = 'jobTitle']").text
                jobhash[:companyName] = job.parser.css("li a[class = 'dice-btn-link']").text
                jobhash[:jobLink] = job.parser.css("link[rel = 'canonical']").attribute('href').value
                jobhash[:location] = job.parser.css("li[class = 'location']").text
                jobhash[:date] = title.match(/- (\d+.+)\|/).captures.sample
                jobhash[:companyId] = job.parser.css("meta[name = 'groupId']").attribute('content').value
                @jobdb << jobhash
            end
        end
        
    end

    
#end

d = Dice_tool.new("java", "San Francisco")
d.synthesis
pp d.jobdb
