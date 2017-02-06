require 'csv'

class Saver
  def initialize(results)
    @results = results
    @file = './public/search_results.csv'
    write_to_file
  end

  def write_to_file
    # create_file unless File.exists?(@file)
    create_file
    CSV.open(@file, 'a') do |csv|
      # each one of these comes out in its own row.
      @results.each do |result|
        csv << [result.title, result.company, result.location, result.date, result.companyid, result.jobid, result.overall, result.culture, result.compensation, result.featured, result.link]
      end
    end
  end

  def create_file
    CSV.open(@file, 'w') do |csv|
      csv << ['Title', 'Company', 'Location', 'Date', 'Company ID', 'Job ID',  'Overall Rating', 'Culture Rating', 'Compensation', 'Featured Review', 'Link']
    end
  end


end
