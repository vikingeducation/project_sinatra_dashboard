require 'csv'

class CSVLoader
	def load(path)
		File.file?(path) ? CSV.read(path) : []
	end
end