require 'csv'

class CSVSaver
	def save(data, path)
		CSV.open(path, 'a+') do |csv|
			if csv.readlines.length <= 0
				a = []
				data.first.each do |key, value|
					a << "#{key}"
				end
				csv << a
			end
			data.each do |job|
				a = []
				job.each do |key, value|
					a << "#{value}"
				end
				csv << a
			end
		end
	end
end