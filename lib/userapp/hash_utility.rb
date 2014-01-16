require 'ostruct'

module UserApp
	class HashUtility
		def self.convert_to_object(source)
			if source.kind_of?(Hash)
				result = OpenStruct.new(source)
				
				source.each do | key, value |
					if source[key].kind_of?(Array) || source[key].is_a?(Hash)
    					result.send("#{key}=", self.convert_to_object(value))
					end
				end

				return result
			elsif source.kind_of?(Array)
				result = []

				source.each do | value |
					result << self.convert_to_object(value)
				end

				return result
			else
				return source
			end
		end
	end
end