require 'csv'

class JobWriter

  def save_results(filepath, results)

    headers = !File.exist?(filepath)

    CSV.open(filepath, 'a') do |csv|

#
      end
    end
  end

end
