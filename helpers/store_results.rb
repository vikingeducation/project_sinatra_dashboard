require 'csv'

module StoreResults

  def save_csv(results)

    # Add headings to file based off Job Struct, if the file isn't already there
    unless File.exist?('jobs.csv')

      CSV.open('jobs.csv', 'a') do |csv|
        csv << results[0].members
      end

    end

    CSV.open('jobs.csv', 'a') do |csv|

      results.each do |job|
        csv << job.to_a
      end

    end

  end

end