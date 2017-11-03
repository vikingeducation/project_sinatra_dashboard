require 'pp'
require 'json'
require 'pry'

require_relative 'review'

class Company

  attr_reader :location

  def initialize(location, response)
    @response = response
    @location = location
  end

  def id
    @id ||= response['employers'][0]['id']
  end

  def name
    @name ||= response['employers'][0]['name']
  end

  def website
    @website ||= response['employers'][0]['website']
  end

  def number_of_ratings
    @number_of_rating ||= response['employers'][0]['number_of_ratings']
  end

  def reviews
    @reviews ||= begin
      review_info = response['employers'][0]['featuredReview']
      [Review.new(review_info)]
    end
  end

  private
  attr_reader :response

end