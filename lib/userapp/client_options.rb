require 'logger'

module UserApp
	class ClientOptions
		@@instance = nil

		attr_accessor :version
		attr_accessor :app_id
		attr_accessor :token
		attr_accessor :base_address
		attr_accessor :throw_errors
		attr_accessor :secure
		attr_accessor :debug
		attr_accessor :logger

		def initialize(*args)
			@version = 1
			@base_address = 'api.userapp.io'
			@throw_errors = true
			@secure = true
			@debug = false

			if !args.nil?
				if args.length == 1 and args[0].class == Hash
					args = args[0]
				end

				self.set(args)
			end
		end

		def logger()
			if @debug and @logger.nil?
				@logger = Logger.new(STDOUT)
			end
			return @logger
		end

		def set(args)
			args.each do | key, value |
				if key and self.respond_to?(key)
					self.send("#{key}=", value)
				end
			end
		end

		def self.get_global(*args)
			if @@instance.nil?
				@@instance = ClientOptions.new(args)
			end
			return @@instance
		end
	end
end