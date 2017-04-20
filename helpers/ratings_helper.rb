module RatingsHelper
  def append_ratings(jobs_array)
    jobs_array.each do |job|
      profiler = CompanyProfiler.new(job[1])
      if profiler.response
        job << profiler.overall_rating
        job << profiler.culture_rating
        job << profiler.compensation_rating
        job << profiler.work_balance_rating
      else
        4.times { job << "N/A" }
      end
    end
  end
  
end