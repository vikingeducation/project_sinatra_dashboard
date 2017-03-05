require 'yaml'

class YAMLSaver
	def save(filename, object)
		data = object.to_yaml
		path = "#{File.dirname(__FILE__)}/data/#{filename}.yaml"
		File.open(path, 'w') do |file|
			file.write(data)
		end
	end
end