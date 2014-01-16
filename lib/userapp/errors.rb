module UserApp
	class Error < Exception
	end

	class InvalidServiceException < Error
	end

	class InvalidMethodException < Error
	end

	class ServiceError < Error
		attr :error_code
		def initialize(error_code, message)
			@error_code = error_code
			super(message)
		end
	end

	class NotAuthorizedError < ServiceError
	end
end