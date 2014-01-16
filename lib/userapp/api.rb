module UserApp
	class API
		@@instance

		def self.get_instance(*args)
			if @@instance.nil?
				@@instance = API.new(args)
			end
			return @@instance
		end
	end
end