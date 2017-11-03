require 'pp'
require 'json'
require 'date'
require 'pry'

class Review

  attr_reader :stars, :title, :date, :headline, :pros, :cons, :url

  def initialize(data)
    @stars = parse_stars(data)
    @title = parse_title(data)
    @date = parse_date(data)
    @headline = parse_headline(data)
    @pros = parse_pros(data)
    @cons = parse_cons(data)
    @url = parse_url(data)
  end

  def parse_stars(data)
    data['overallNumeric']
  end

  def parse_title(data)
    data['jobTitle']
  end

  def parse_date(data)
    date = data['reviewDateTime']
    Date.parse(date).strftime('%m-%d-%Y')
  end

  def parse_headline(data)
    data['headline']
  end

  def parse_pros(data)
    data['pros']
  end

  def parse_cons(data)
    data['cons']
  end

  def parse_url(data)
    data['attributionURL']
  end

end