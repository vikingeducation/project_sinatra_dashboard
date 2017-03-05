require 'yaml'

class YAMLLoader
	def load(path)
		if File.file?(path)
			file = File.read(path)
			yaml = YAML.load(file)
			yaml.each do |key, value|
				self.class.send(:attr_accessor, key)
				send("#{key}=".to_sym, value)
			end
		end
	end
end