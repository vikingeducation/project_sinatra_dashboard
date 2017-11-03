require 'pp'
require 'json'
require 'pry'

require_relative 'review'

class Company

  attr_reader :id, :name, :location, :website, :number_of_ratings, :reviews

  def initialize(location, response)
    @id = parse_id(response)
    @name = parse_name(response)
    @location = location
    @website = parse_website(response)
    @number_of_ratings = parse_number_of_ratings(response)
    @reviews = []
    parse_featured_review(response)
  end

  def parse_id(response)
    response['employers'][0]['id']
  end

  def parse_name(response)
    response['employers'][0]['name']
  end

  def parse_website(response)
    response['employers'][0]['website']
  end

  def parse_number_of_ratings(response)
    response['employers'][0]['number_of_ratings']
  end

  def parse_featured_review(response)
    review_info = response['employers'][0]['featuredReview']
    @reviews << Review.new(review_info)
  end

end