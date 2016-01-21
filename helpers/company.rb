


class Company

  attr_accessor :overallRating, :cultureAndValuesRating, :compensationAndBenefitsRating, :pros, :cons

  def initialize(overallRating:, cultureAndValuesRating:, compensationAndBenefitsRating:, pros:, cons:)
    @overallRating = overallRating
    @cultureAndValuesRating = cultureAndValuesRating
    @compensationAndBenefitsRating = compensationAndBenefitsRating
    @pros = pros # first 100 chars of ["featuredReview"]["pros"]
    @cons = cons # first 100 chars of ["featuredReview"]["cons"]
  end

  # def to_a
  #   [overallRating, cultureAndValuesRating, compensationAndBenefitsRating, pros, cons]
  # end



end